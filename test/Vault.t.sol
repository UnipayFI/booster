// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import { Vault } from "../contracts/Vault.sol";
import { StakedToken } from "../contracts/StakedToken.sol";
import { WithdrawVault } from "../contracts/WithdrawVault.sol";
import { VaultEscrow } from "../contracts/VaultEscrow.sol";
import { ClaimItem } from "../contracts/IVault.sol";
import { MockToken } from "../contracts/mock/MockToken.sol";

contract VaultBoosterTest is Test {
  uint256 private constant _BASE = 10_000;
  uint256 private constant _ONE_YEAR = 31557600;
  uint256 private constant _PENALTY_RATE = 50; // 0.5%

  Vault internal _vault;
  StakedToken internal _stakedToken;
  WithdrawVault internal _withdrawVault;
  VaultEscrow internal _vaultEscrow;
  MockToken internal _underlying;

  address internal _admin;
  address internal _bot;
  address internal _ceffu;
  address internal _distributor;
  address internal _alice;

  uint256 internal _waitingTime = 3 days;
  uint256 internal _rewardRate = 1_000; // 10% APR

  function setUp() public {
    _admin = address(this);
    _bot = makeAddr("bot");
    _ceffu = makeAddr("ceffu");
    _distributor = makeAddr("distributor");
    _alice = makeAddr("alice");

    _underlying = new MockToken("Mock Token", "MOCK", 18, _admin);
    _stakedToken = new StakedToken("Staked Mock", "sMOCK", _admin);

    address[] memory tokens = new address[](1);
    tokens[0] = address(_underlying);

    address[] memory stakedTokens = new address[](1);
    stakedTokens[0] = address(_stakedToken);

    uint256[] memory rewardRates = new uint256[](1);
    rewardRates[0] = _rewardRate;

    uint256[] memory minStakeAmounts = new uint256[](1);
    minStakeAmounts[0] = 1 ether;

    uint256[] memory maxStakeAmounts = new uint256[](1);
    maxStakeAmounts[0] = 1_000_000 ether;

    _withdrawVault = new WithdrawVault(tokens, _admin, _bot, _ceffu);
    _vaultEscrow = new VaultEscrow(_admin);

    _vault = new Vault(
      tokens,
      stakedTokens,
      rewardRates,
      minStakeAmounts,
      maxStakeAmounts,
      _admin,
      _bot,
      _ceffu,
      _waitingTime,
      payable(address(_withdrawVault)),
      _distributor,
      address(_vaultEscrow)
    );

    _stakedToken.setMinter(address(_vault), address(_vault));
    _withdrawVault.setVault(address(_vault));
    _vaultEscrow.setVault(address(_vault), true);
    _vaultEscrow.setDistributor(_distributor, true);

    _vault.unpause();

    // distribute test funds
    _underlying.transfer(_alice, 1_000 ether);
  }

  function _stakeForAlice(uint256 amount) internal {
    vm.startPrank(_alice);
    _underlying.approve(address(_vault), amount);
    _vault.stake_66380860(address(_underlying), amount);
    vm.stopPrank();
  }

  function _expectedReward(uint256 principal, uint256 elapsed) internal view returns (uint256) {
    return (principal * _rewardRate * elapsed) / (_ONE_YEAR * _BASE);
  }

  function testStakeUpdatesState() public {
    uint256 amount = 100 ether;
    _stakeForAlice(amount);

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), amount);
    uint256 stakedBalance = _stakedToken.balanceOf(_alice);
    uint256 assetsEquivalent = _vault.convertToAssets(stakedBalance, address(_underlying));
    assertApproxEqAbs(assetsEquivalent, amount, 100);
    assertEq(_vault.totalStakeAmountByToken(address(_underlying)), amount);
    assertEq(_vault.getTVL(address(_underlying)), amount);
  }

  function testRequestAndClaimAll() public {
    uint256 amount = 200 ether;
    uint256 aliceInitialBalance = _underlying.balanceOf(_alice);
    _stakeForAlice(amount);

    uint256 elapsed = _ONE_YEAR;
    vm.warp(block.timestamp + elapsed);

    vm.startPrank(_alice);
    uint256 queueId = _vault.requestClaim_8135334(address(_underlying), type(uint256).max);
    vm.stopPrank();

    ClaimItem memory claimItem = _vault.getClaimQueueInfo(queueId);
    uint256 expectedReward = _expectedReward(amount, elapsed);

    assertEq(claimItem.totalAmount, amount + expectedReward);
    assertEq(claimItem.rewardAmount, expectedReward);
    assertEq(claimItem.principalAmount, amount);

    uint256[] memory queueIds = _vault.getClaimQueueIDs(_alice, address(_underlying));
    assertEq(queueIds.length, 1);
    assertEq(queueIds[0], queueId);

    // fund withdraw vault before claim
    _underlying.transfer(address(_withdrawVault), claimItem.totalAmount);

    vm.warp(claimItem.claimTime + 1);

    vm.startPrank(_alice);
    _vault.claim_41202704(queueId, address(_underlying));
    vm.stopPrank();

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), 0);
    assertEq(_stakedToken.balanceOf(_alice), 0);
    assertEq(_vault.getTVL(address(_underlying)), 0);
    assertEq(_underlying.balanceOf(_alice), aliceInitialBalance);
    assertEq(_underlying.balanceOf(address(_vaultEscrow)), expectedReward);
    assertEq(_vaultEscrow.pendingReward(_alice, address(_underlying)), expectedReward);
    assertEq(_vault.getClaimHistoryLength(_alice, address(_underlying)), 1);
  }

  function testDistributorCanReleaseRewards() public {
    uint256 amount = 200 ether;
    _stakeForAlice(amount);

    uint256 elapsed = _ONE_YEAR / 2;
    vm.warp(block.timestamp + elapsed);

    vm.startPrank(_alice);
    uint256 queueId = _vault.requestClaim_8135334(address(_underlying), type(uint256).max);
    vm.stopPrank();

    ClaimItem memory claimItem = _vault.getClaimQueueInfo(queueId);
    _underlying.transfer(address(_withdrawVault), claimItem.totalAmount);

    vm.warp(claimItem.claimTime + 1);

    uint256 aliceBalanceBeforeClaim = _underlying.balanceOf(_alice);

    vm.startPrank(_alice);
    _vault.claim_41202704(queueId, address(_underlying));
    vm.stopPrank();

    assertEq(_underlying.balanceOf(_alice), aliceBalanceBeforeClaim + claimItem.principalAmount);
    assertEq(_vaultEscrow.pendingReward(_alice, address(_underlying)), claimItem.rewardAmount);

    uint256 distributorBalanceBefore = _underlying.balanceOf(_distributor);
    uint256 aliceBalanceBeforeDisperse = _underlying.balanceOf(_alice);

    vm.startPrank(_distributor);
    uint256 dispersed = _vaultEscrow.disperseToken(
      _alice,
      address(_underlying),
      claimItem.rewardAmount,
      address(_underlying),
      claimItem.rewardAmount
    );
    vm.stopPrank();

    assertEq(dispersed, claimItem.rewardAmount);
    assertEq(_vaultEscrow.pendingReward(_alice, address(_underlying)), 0);
    assertEq(_underlying.balanceOf(_distributor), distributorBalanceBefore);

    assertEq(_underlying.balanceOf(_alice), aliceBalanceBeforeDisperse + claimItem.rewardAmount);
  }

  function testCancelClaimRestoresPosition() public {
    uint256 amount = 150 ether;
    _stakeForAlice(amount);

    vm.warp(block.timestamp + 30 days);

    vm.startPrank(_alice);
    uint256 queueId = _vault.requestClaim_8135334(address(_underlying), amount / 2);
    vm.stopPrank();

    _vault.setCancelEnable(false);

    vm.startPrank(_alice);
    _vault.cancelClaim(queueId, address(_underlying));
    vm.stopPrank();

    assertEq(_vault.getClaimHistoryLength(_alice, address(_underlying)), 0);
    assertApproxEqAbs(_vault.getStakedAmount(_alice, address(_underlying)), amount, 100);
    uint256 stakedBalance = _stakedToken.balanceOf(_alice);
    uint256 assetsEquivalent = _vault.convertToAssets(stakedBalance, address(_underlying));
    uint256 pendingReward = _vault.getClaimableRewards(_alice, address(_underlying));
    assertApproxEqAbs(assetsEquivalent, amount + pendingReward, 100);
    assertGt(pendingReward, 0);

    uint256[] memory queueIds = _vault.getClaimQueueIDs(_alice, address(_underlying));
    assertEq(queueIds.length, 0);
  }

  function testFlashWithdrawAppliesPenalty() public {
    uint256 amount = 100 ether;
    uint256 aliceInitialBalance = _underlying.balanceOf(_alice);
    _stakeForAlice(amount);

    _vault.setFlashEnable(false);
    uint256 elapsed = _ONE_YEAR / 4;
    vm.warp(block.timestamp + elapsed);

    uint256 expectedReward = _expectedReward(amount, elapsed);
    _underlying.transfer(address(_vault), expectedReward);

    uint256 principalPayout = (amount * (_BASE - _PENALTY_RATE)) / _BASE;
    uint256 rewardPayout = (expectedReward * (_BASE - _PENALTY_RATE)) / _BASE;
    uint256 expectedFee = amount + expectedReward - principalPayout - rewardPayout;

    vm.startPrank(_alice);
    _vault.flashWithdrawWithPenalty(address(_underlying), type(uint256).max);
    vm.stopPrank();

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), 0);
    assertEq(_stakedToken.balanceOf(_alice), 0);
    assertEq(_underlying.balanceOf(_alice), aliceInitialBalance - amount + principalPayout);
    assertEq(_vaultEscrow.pendingReward(_alice, address(_underlying)), rewardPayout);
    assertEq(_underlying.balanceOf(address(_vaultEscrow)), rewardPayout);
    assertEq(_underlying.balanceOf(address(_vault)), expectedFee);
  }
}
