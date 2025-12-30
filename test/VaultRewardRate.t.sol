// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import { Vault } from "../contracts/vault/Vault.sol";
import { StakedToken } from "../contracts/vault/StakedToken.sol";
import { WithdrawVault } from "../contracts/vault/WithdrawVault.sol";
import { ClaimItem } from "../contracts/interfaces/IVault.sol";
import { MockToken } from "../contracts/mock/MockToken.sol";

contract VaultBoosterRewardRateTest is Test {
  uint256 private constant _BASE = 10_000;
  uint256 private constant _ONE_YEAR = 31557600;

  Vault internal _vault;
  StakedToken internal _stakedToken;
  WithdrawVault internal _withdrawVault;
  MockToken internal _underlying;

  address internal _admin;
  address internal _bot;
  address internal _ceffu;
  address internal _distributor;

  address internal _userA;
  address internal _userB;
  address internal _userC;
  address internal _userD;

  uint256 internal _waitingTime = 3 days;

  // Scenario Rates
  uint256 internal _rateW1 = 776; // 7.76%
  uint256 internal _rateW2 = 0; // 0%
  uint256 internal _rateW3 = 500; // 5.00%

  function setUp() public {
    _admin = address(this);
    _bot = makeAddr("bot");
    _ceffu = makeAddr("ceffu");
    _distributor = makeAddr("distributor");

    _userA = makeAddr("userA");
    _userB = makeAddr("userB");
    _userC = makeAddr("userC");
    _userD = makeAddr("userD");

    _underlying = new MockToken("Mock Token", "MOCK", 18, _admin);
    _stakedToken = new StakedToken("Staked Mock", "sMOCK", _admin);

    address[] memory tokens = new address[](1);
    tokens[0] = address(_underlying);

    address[] memory stakedTokens = new address[](1);
    stakedTokens[0] = address(_stakedToken);

    // Initial Rate: Week 1 Rate (776)
    uint256[] memory rewardRates = new uint256[](1);
    rewardRates[0] = _rateW1;

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

    // Distribute tokens to users
    uint256 amount = 100 ether;
    _underlying.transfer(_userA, amount);
    _underlying.transfer(_userB, amount);
    _underlying.transfer(_userC, amount);
    _underlying.transfer(_userD, amount);
  }

  function testRewardRateVariationScenario() public {
    uint256 amount = 100 ether;
    uint256 oneWeek = 7 days;

    // ==========================================
    // T = 0: Week 1 Start
    // Rate = 7.76% (Set in constructor)
    // User A and B Stake
    // ==========================================
    vm.startPrank(_userA);
    _underlying.approve(address(_vault), amount);
    _vault.stake_66380860(address(_underlying), amount);
    vm.stopPrank();

    vm.startPrank(_userB);
    _underlying.approve(address(_vault), amount);
    _vault.stake_66380860(address(_underlying), amount);
    vm.stopPrank();

    // ==========================================
    // T = 1 Week: Week 2 Start
    // Rate changes to 0%
    // User C and D Stake
    // ==========================================
    vm.warp(604801);

    _vault.setRewardRate(address(_underlying), _rateW2);

    vm.startPrank(_userC);
    _underlying.approve(address(_vault), amount);
    _vault.stake_66380860(address(_underlying), amount);
    vm.stopPrank();

    vm.startPrank(_userD);
    _underlying.approve(address(_vault), amount);
    _vault.stake_66380860(address(_underlying), amount);
    vm.stopPrank();

    // ==========================================
    // T = 2 Weeks: Week 3 Start
    // Rate changes to 5.00% (500)
    // User B and C Unstake
    // ==========================================
    vm.warp(604801 + oneWeek);

    _vault.setRewardRate(address(_underlying), _rateW3);

    // User B Unstakes (Staked for W1 + W2)
    // Expected: W1(7.76%) + W2(0%)
    vm.startPrank(_userB);
    uint256 queueIdB = _vault.requestClaim_8135334(address(_underlying), type(uint256).max, false);
    vm.stopPrank();

    // User C Unstakes (Staked for W2)
    // Expected: W2(0%)
    vm.startPrank(_userC);
    uint256 queueIdC = _vault.requestClaim_8135334(address(_underlying), type(uint256).max, false);
    vm.stopPrank();

    // Verify B's Reward
    uint256 expectedRewardB = (amount * _rateW1 * oneWeek) / (_ONE_YEAR * _BASE);
    ClaimItem memory itemB = _vault.getClaimQueueInfo(queueIdB);
    console.log("User B Expected Reward:", expectedRewardB);
    console.log("User B Actual Reward:  ", itemB.rewardAmount);
    assertApproxEqAbs(itemB.rewardAmount, expectedRewardB, 100);

    // Verify C's Reward
    ClaimItem memory itemC = _vault.getClaimQueueInfo(queueIdC);
    console.log("User C Expected Reward: 0");
    console.log("User C Actual Reward:  ", itemC.rewardAmount);
    assertEq(itemC.rewardAmount, 0);

    // ==========================================
    // T = 3 Weeks: Week 3 End
    // User A and D Unstake
    // ==========================================
    vm.warp(604801 + oneWeek * 2);

    (uint256 currentRate, ) = _vault.getCurrentRewardRate(address(_underlying));

    uint256 stakedA = _vault.getStakedAmount(_userA, address(_underlying));
    uint256 claimableA_Pre = _vault.getClaimableRewards(_userA, address(_underlying));

    // User A Unstakes (Staked for W1 + W2 + W3)
    // Expected: W1(7.76%) + W2(0%) + W3(5.00%)
    vm.startPrank(_userA);
    uint256 queueIdA = _vault.requestClaim_8135334(address(_underlying), type(uint256).max, false);
    vm.stopPrank();

    // User D Unstakes (Staked for W2 + W3)
    // Expected: W2(0%) + W3(5.00%)
    vm.startPrank(_userD);
    uint256 queueIdD = _vault.requestClaim_8135334(address(_underlying), type(uint256).max, false);
    vm.stopPrank();

    // Verify Rewards
    // User A: W1(7.76%) + W2(0%) + W3(5.00%)
    // W1: 100 * 0.0776 * 7/365.25 = 0.14872 ether
    // W2: 0
    // W3: 100 * 0.0500 * 7/365.25 = 0.09582 ether
    // Total A = 0.24454 ether
    uint256 rewardW1_A = 148720054757015742;
    uint256 rewardW3_A = 95824777549623545;
    uint256 expectedRewardA = rewardW1_A + rewardW3_A;

    ClaimItem memory itemA = _vault.getClaimQueueInfo(queueIdA);
    console.log("User A Expected Reward:", expectedRewardA);
    console.log("User A Actual Reward:  ", itemA.rewardAmount);
    assertApproxEqAbs(itemA.rewardAmount, expectedRewardA, 200);

    // User D: W2(0%) + W3(5.00%)
    // Total D = 0.09582 ether
    uint256 expectedRewardD = rewardW3_A;

    ClaimItem memory itemD = _vault.getClaimQueueInfo(queueIdD);
    console.log("User D Expected Reward:", expectedRewardD);
    console.log("User D Actual Reward:  ", itemD.rewardAmount);
    assertApproxEqAbs(itemD.rewardAmount, expectedRewardD, 100);
  }
}
