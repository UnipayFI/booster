// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVaultEscrow {
  function recordWithdraw(address user, address token, uint256 amount) external;

  function disperseToken(
    address user,
    address recordToken,
    uint256 freezeRecordAmount,
    address from,
    address withdrawToken,
    uint256 withdrawAmount
  ) external returns (uint256);

  function pendingWithdraw(address user, address token) external view returns (uint256);
}
