// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import { Vault } from "../contracts/vault/Vault.sol";
import { StakedToken } from "../contracts/vault/StakedToken.sol";
import { WithdrawVault } from "../contracts/vault/WithdrawVault.sol";
import { ClaimItem } from "../contracts/interfaces/IVault.sol";
import { MockToken } from "../contracts/mock/MockToken.sol";

contract VaultBoosterTest is Test {
  uint256 private constant _BASE = 10_000;
  uint256 private constant _ONE_YEAR = 31557600;
  uint256 private constant _PENALTY_RATE = 50; // 0.5%

  Vault internal _vault;
  StakedToken internal _stakedToken;
  WithdrawVault internal _withdrawVault;
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
      _distributor
    );

    _stakedToken.setMinter(address(_vault), address(_vault));
    _withdrawVault.setVault(address(_vault));

    _vault.unpause();
    _vault.setCancelEnable(false);

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
    uint256 aliceBalanceBefore = _underlying.balanceOf(_alice);

    _stakeForAlice(amount);

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), amount);
    uint256 stakedBalance = _stakedToken.balanceOf(_alice);
    uint256 assetsEquivalent = _vault.convertToAssets(stakedBalance, address(_underlying));
    assertEq(assetsEquivalent, amount);
    assertEq(_vault.getTVL(address(_underlying)), amount);
    assertEq(_underlying.balanceOf(_alice), aliceBalanceBefore - amount);
  }

  function testRequestAndClaimAll() public {
    uint256 amount = 200 ether;
    uint256 aliceInitialBalance = _underlying.balanceOf(_alice);
    _stakeForAlice(amount);

    uint256 elapsed = _ONE_YEAR;
    vm.warp(block.timestamp + elapsed);

    vm.startPrank(_alice);
    uint256 queueId = _vault.requestClaim_8135334(address(_underlying), type(uint256).max, false);
    vm.stopPrank();

    ClaimItem memory claimItem = _vault.getClaimQueueInfo(queueId);
    uint256 expectedReward = _expectedReward(amount, elapsed);

    assertEq(claimItem.principalAmount, amount);
    assertEq(claimItem.rewardAmount, expectedReward);
    assertEq(claimItem.totalAmount, claimItem.principalAmount + claimItem.rewardAmount);
    assertFalse(claimItem.isSusduTokenWithdraw);
    assertFalse(claimItem.isDone);

    uint256[] memory queueIds = _vault.getClaimQueueIDs(_alice, address(_underlying));
    assertEq(queueIds.length, 1);
    assertEq(queueIds[0], queueId);

    _underlying.transfer(address(_withdrawVault), claimItem.totalAmount);

    vm.warp(claimItem.claimTime + 1);

    uint256 aliceBalanceBeforeClaim = _underlying.balanceOf(_alice);

    vm.startPrank(_alice);
    _vault.claim_41202704(queueId, address(_underlying));
    vm.stopPrank();

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), 0);
    assertEq(_stakedToken.balanceOf(_alice), 0);
    assertEq(_vault.getTVL(address(_underlying)), 0);
    assertEq(_vault.getClaimHistoryLength(_alice, address(_underlying)), 1);

    assertEq(_underlying.balanceOf(_alice), aliceBalanceBeforeClaim + claimItem.totalAmount);
    assertEq(_underlying.balanceOf(_alice), aliceInitialBalance + expectedReward);
  }

  function testRequestClaimRewardsOnlyUsesRewardsFirst() public {
    uint256 amount = 200 ether;
    uint256 aliceInitialBalance = _underlying.balanceOf(_alice);
    _stakeForAlice(amount);

    uint256 elapsed = 120 days;
    vm.warp(block.timestamp + elapsed);

    uint256 totalReward = _expectedReward(amount, elapsed);
    uint256 withdrawAmount = totalReward;
    assertGt(withdrawAmount, 0);

    vm.startPrank(_alice);
    uint256 queueId = _vault.requestClaim_8135334(address(_underlying), withdrawAmount, false);
    vm.stopPrank();

    ClaimItem memory queueItem = _vault.getClaimQueueInfo(queueId);

    assertEq(queueItem.rewardAmount, withdrawAmount);
    assertEq(queueItem.principalAmount, 0);
    assertEq(queueItem.totalAmount, withdrawAmount);
    assertFalse(queueItem.isSusduTokenWithdraw);
    assertFalse(queueItem.isDone);

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), amount);
    assertGt(_stakedToken.balanceOf(_alice), 0);

    uint256 assetsEquivalent = _vault.convertToAssets(_stakedToken.balanceOf(_alice), address(_underlying));
    assertGt(amount, assetsEquivalent);
    assertApproxEqAbs(assetsEquivalent, amount + totalReward - withdrawAmount, 200);

    _underlying.transfer(address(_withdrawVault), queueItem.totalAmount);

    vm.warp(queueItem.claimTime + 1);

    uint256 aliceBalanceBeforeClaim = _underlying.balanceOf(_alice);

    vm.startPrank(_alice);
    _vault.claim_41202704(queueId, address(_underlying));
    vm.stopPrank();

    assertEq(_vault.getClaimHistoryLength(_alice, address(_underlying)), 1);
    assertEq(_underlying.balanceOf(_alice), aliceBalanceBeforeClaim + queueItem.totalAmount);
    assertEq(_underlying.balanceOf(_alice), aliceInitialBalance - amount + queueItem.totalAmount);
    assertEq(_vault.getTVL(address(_underlying)), amount);

    uint256 remainingRewards = _vault.getClaimableRewards(_alice, address(_underlying));
    uint256 waitElapsed = (queueItem.claimTime + 1) - queueItem.requestTime;
    uint256 expectedRemainingRewards = totalReward - withdrawAmount + _expectedReward(amount, waitElapsed);
    assertEq(remainingRewards, expectedRemainingRewards);
  }

  function testCancelClaimRestoresPrincipalAndRewards() public {
    uint256 amount = 180 ether;
    _stakeForAlice(amount);

    uint256 elapsed = 200 days;
    vm.warp(block.timestamp + elapsed);

    vm.startPrank(_alice);
    uint256 queueId = _vault.requestClaim_8135334(address(_underlying), type(uint256).max, false);
    vm.stopPrank();

    ClaimItem memory queued = _vault.getClaimQueueInfo(queueId);
    assertEq(queued.principalAmount, amount);
    assertGt(queued.rewardAmount, 0);
    assertFalse(queued.isDone);

    vm.startPrank(_alice);
    _vault.cancelClaim(queueId, address(_underlying));
    vm.stopPrank();

    ClaimItem memory cleared = _vault.getClaimQueueInfo(queueId);
    assertEq(cleared.totalAmount, 0);
    assertEq(cleared.user, address(0));

    assertEq(_vault.getClaimHistoryLength(_alice, address(_underlying)), 0);

    uint256[] memory queueIds = _vault.getClaimQueueIDs(_alice, address(_underlying));
    assertEq(queueIds.length, 0);

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), amount);

    uint256 claimableRewards = _vault.getClaimableRewards(_alice, address(_underlying));
    assertEq(claimableRewards, queued.rewardAmount);

    uint256 stakedAssets = _vault.convertToAssets(_stakedToken.balanceOf(_alice), address(_underlying));
    assertEq(stakedAssets, queued.principalAmount + queued.rewardAmount);
  }

  function testRequestSusduWithdrawRecords() public {
    uint256 amount = 150 ether;
    _stakeForAlice(amount);

    uint256 elapsed = 30 days;
    vm.warp(block.timestamp + elapsed);

    uint256 expectedReward = _expectedReward(amount, elapsed);
    _underlying.transfer(address(_withdrawVault), amount + expectedReward + 1 ether);

    uint256 ceffuBalanceBefore = _underlying.balanceOf(_ceffu);

    vm.startPrank(_alice);
    uint256 queueId = _vault.requestClaim_8135334(address(_underlying), type(uint256).max, true);
    vm.stopPrank();

    ClaimItem memory queueItem = _vault.getClaimQueueInfo(queueId);

    assertTrue(queueItem.isDone);
    assertTrue(queueItem.isSusduTokenWithdraw);
    assertEq(queueItem.totalAmount, queueItem.principalAmount + queueItem.rewardAmount);
    assertEq(_vault.getClaimHistoryLength(_alice, address(_underlying)), 1);
    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), 0);
    assertEq(_stakedToken.balanceOf(_alice), 0);
    assertEq(_vault.getTVL(address(_underlying)), 0);

    assertEq(_underlying.balanceOf(_ceffu), ceffuBalanceBefore + queueItem.totalAmount);

    uint256[] memory queueIds = _vault.getClaimQueueIDs(_alice, address(_underlying));
    assertEq(queueIds.length, 0);

    assertEq(queueItem.rewardAmount, expectedReward);
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

    vm.startPrank(_alice);
    _vault.flashWithdrawWithPenalty(address(_underlying), type(uint256).max);
    vm.stopPrank();

    uint256 principalPayout = (amount * (_BASE - _PENALTY_RATE)) / _BASE;
    uint256 rewardPayout = (expectedReward * (_BASE - _PENALTY_RATE)) / _BASE;
    uint256 expectedFee = amount + expectedReward - principalPayout - rewardPayout;

    assertEq(_vault.getStakedAmount(_alice, address(_underlying)), 0);
    assertEq(_stakedToken.balanceOf(_alice), 0);
    assertEq(_vault.getClaimHistoryLength(_alice, address(_underlying)), 1);
    assertEq(_underlying.balanceOf(_alice), aliceInitialBalance - amount + principalPayout + rewardPayout);
    assertEq(_underlying.balanceOf(address(_vault)), expectedFee);
  }
}
