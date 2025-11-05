// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultEscrow {
  function recordReward(address user, address token, uint256 amount) external;

  function disperseToken(
    address user,
    address recordToken,
    uint256 freezeRecordAmount,
    address rewardToken,
    uint256 rewardAmount
  ) external returns (uint256);

  function pendingReward(address user, address token) external view returns (uint256);
}
