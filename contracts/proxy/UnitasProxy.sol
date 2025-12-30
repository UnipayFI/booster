// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../libraries/SingleAdminAccessControl.sol";
import "../interfaces/IUnitasMintingV2.sol";
import "../interfaces/IERC4626Minimal.sol";

contract UnitasProxy is SingleAdminAccessControl, ReentrancyGuard {
  using SafeERC20 for IERC20;

  error InvalidZeroAddress();
  error InvalidBeneficiary();

  bytes32 public constant MINT_CALLER_ROLE = keccak256("MINT_CALLER_ROLE");

  IUnitasMintingV2 public immutable minting;
  IERC4626Minimal public immutable staked;
  address public immutable usdu;

  constructor(IUnitasMintingV2 _minting, IERC4626Minimal _staked, address _usdu, address admin) {
    if (address(_minting) == address(0) || address(_staked) == address(0) || address(_usdu) == address(0)) {
      revert InvalidZeroAddress();
    }
    if (admin == address(0)) {
      revert InvalidZeroAddress();
    }

    minting = _minting;
    staked = _staked;
    usdu = _usdu;

    _grantRole(DEFAULT_ADMIN_ROLE, admin);
  }

  function mintAndStake(
    IUnitasMintingV2.Order calldata order,
    IUnitasMintingV2.Route calldata route,
    IUnitasMintingV2.Signature calldata signature,
    address stakeReceiver
  ) external nonReentrant onlyRole(MINT_CALLER_ROLE) returns (uint256 shares) {
    if (stakeReceiver == address(0)) {
      revert InvalidZeroAddress();
    }
    if (order.beneficiary != address(this)) {
      revert InvalidBeneficiary();
    }

    uint256 amount = uint256(order.usdu_amount);

    minting.mint(order, route, signature);

    IERC20(usdu).approve(address(staked), 0);
    IERC20(usdu).approve(address(staked), amount);

    shares = staked.deposit(amount, stakeReceiver);
  }
}
