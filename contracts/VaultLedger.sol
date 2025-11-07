// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./IVaultLedger.sol";

contract VaultLedger is IVaultLedger, AccessControl, ReentrancyGuard {
  using SafeERC20 for IERC20;

  bytes32 public constant VAULT_ROLE = keccak256("VAULT_ROLE");
  bytes32 public constant DISTRIBUTOR_ROLE = keccak256("DISTRIBUTOR_ROLE");

  // user => recordToken => disperse summary
  mapping(address => mapping(address => DisperseRecord)) private _disperseRecords;
  // allow token list to disperse
  mapping(address => bool) private _allowTokens;

  event WithdrawRecorded(address indexed user, address indexed token, uint256 amount);
  event WithdrawDispersed(
    address indexed user,
    address indexed recordToken,
    uint256 recordAmount,
    address withdrawToken,
    uint256 withdrawAmount,
    address from
  );
  event VaultRoleGranted(address indexed vault);
  event VaultRoleRevoked(address indexed vault);

  constructor(address admin) {
    require(admin != address(0), "admin zero");
    _grantRole(DEFAULT_ADMIN_ROLE, admin);
    _grantRole(DISTRIBUTOR_ROLE, admin);
  }

  function addAllowToken(address token) external onlyRole(DEFAULT_ADMIN_ROLE) {
    require(token != address(0), "token zero");
    _allowTokens[token] = true;
  }

  function removeAllowToken(address token) external onlyRole(DEFAULT_ADMIN_ROLE) {
    require(token != address(0), "token zero");
    _allowTokens[token] = false;
  }

  function recordWithdraw(
    address user,
    address token,
    uint256 amount
  ) external override onlyRole(VAULT_ROLE) nonReentrant {
    require(user != address(0), "user zero");
    require(token != address(0), "token zero");
    require(amount > 0, "amount zero");

    DisperseRecord storage record = _disperseRecords[user][token];
    record.recordedAmount += amount;
    record.lastUpdated = block.timestamp;

    emit WithdrawRecorded(user, token, amount);
  }

  function disperseToken(
    address user,
    address recordToken,
    uint256 freezeRecordAmount,
    address from,
    address withdrawToken,
    uint256 withdrawAmount
  ) external override onlyRole(DISTRIBUTOR_ROLE) nonReentrant returns (uint256) {
    require(user != address(0), "user zero");
    require(recordToken != address(0) && withdrawToken != address(0), "token zero");
    require(_allowTokens[withdrawToken], "token not allowed");
    require(freezeRecordAmount > 0 && withdrawAmount > 0, "amount zero");

    DisperseRecord storage record = _disperseRecords[user][recordToken];
    uint256 availableAmount = record.recordedAmount - record.deductedAmount;
    require(availableAmount >= freezeRecordAmount, "insufficient withdraw");

    IERC20(withdrawToken).safeTransferFrom(from, user, withdrawAmount);

    record.deductedAmount += freezeRecordAmount;
    record.dispersedAmount += withdrawAmount;
    record.lastUpdated = block.timestamp;

    emit WithdrawDispersed(user, recordToken, freezeRecordAmount, withdrawToken, withdrawAmount, from);
    return withdrawAmount;
  }

  function getAvailableAmount(address user, address token) external view override returns (uint256) {
    DisperseRecord memory record = _disperseRecords[user][token];
    return record.recordedAmount - record.deductedAmount;
  }

  function getDisperseRecord(address user, address recordToken) external view override returns (DisperseRecord memory) {
    return _disperseRecords[user][recordToken];
  }

  function setVault(address vault, bool enabled) external onlyRole(DEFAULT_ADMIN_ROLE) {
    require(vault != address(0), "vault zero");
    if (enabled) {
      _grantRole(VAULT_ROLE, vault);
      emit VaultRoleGranted(vault);
    } else {
      _revokeRole(VAULT_ROLE, vault);
      emit VaultRoleRevoked(vault);
    }
  }

  function setDistributor(address distributor, bool enabled) external onlyRole(DEFAULT_ADMIN_ROLE) {
    require(distributor != address(0), "distributor zero");
    if (enabled) {
      _grantRole(DISTRIBUTOR_ROLE, distributor);
    } else {
      _revokeRole(DISTRIBUTOR_ROLE, distributor);
    }
  }
}
