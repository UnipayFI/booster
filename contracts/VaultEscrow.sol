// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "./IVaultEscrow.sol";

contract VaultEscrow is IVaultEscrow, AccessControl, ReentrancyGuard {
  using SafeERC20 for IERC20;

  bytes32 public constant VAULT_ROLE = keccak256("VAULT_ROLE");
  bytes32 public constant DISTRIBUTOR_ROLE = keccak256("DISTRIBUTOR_ROLE");

  // user => token => amount
  mapping(address => mapping(address => uint256)) private _pendingRewards;

  event RewardRecorded(address indexed user, address indexed token, uint256 amount);
  event RewardDispersed(
    address indexed user,
    address indexed recordToken,
    uint256 recordAmount,
    address indexed rewardToken,
    uint256 rewardAmount,
    address recipient,
    address caller
  );
  event VaultRoleGranted(address indexed vault);
  event VaultRoleRevoked(address indexed vault);

  constructor(address admin) {
    require(admin != address(0), "admin zero");
    _grantRole(DEFAULT_ADMIN_ROLE, admin);
  }

  function recordReward(
    address user,
    address token,
    uint256 amount
  ) external override onlyRole(VAULT_ROLE) nonReentrant {
    require(user != address(0), "user zero");
    require(token != address(0), "token zero");
    require(amount > 0, "amount zero");

    _pendingRewards[user][token] += amount;

    emit RewardRecorded(user, token, amount);
  }

  function disperseToken(
    address user,
    address recordToken,
    uint256 freezeRecordAmount,
    address rewardToken,
    uint256 rewardAmount
  ) external override nonReentrant returns (uint256) {
    require(user != address(0), "user zero");
    require(recordToken != address(0) && rewardToken != address(0), "token zero");
    require(freezeRecordAmount > 0 && rewardAmount > 0, "amount zero");
    require(hasRole(DISTRIBUTOR_ROLE, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "unauthorized");

    uint256 pending = _pendingRewards[user][recordToken];
    require(pending >= freezeRecordAmount, "insufficient reward");

    _pendingRewards[user][recordToken] = pending - freezeRecordAmount;

    IERC20(rewardToken).safeTransfer(user, rewardAmount);

    emit RewardDispersed(user, recordToken, freezeRecordAmount, rewardToken, rewardAmount, user, msg.sender);
    return rewardAmount;
  }

  function pendingReward(address user, address token) external view override returns (uint256) {
    return _pendingRewards[user][token];
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
