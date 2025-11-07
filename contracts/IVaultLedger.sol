// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct DisperseRecord {
  uint256 recordedAmount;
  uint256 deductedAmount;
  uint256 dispersedAmount;
  uint256 lastUpdated;
}

interface IVaultLedger {
  function recordWithdraw(address user, address token, uint256 amount) external;

  function disperseToken(
    address user,
    address recordToken,
    uint256 freezeRecordAmount,
    address from,
    address withdrawToken,
    uint256 withdrawAmount
  ) external returns (uint256);

  function getAvailableAmount(address user, address token) external view returns (uint256);

  function getDisperseRecord(address user, address recordToken) external view returns (DisperseRecord memory);
}
