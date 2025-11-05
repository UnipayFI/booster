// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Utils {
  error ZeroAddress();

  // Use this when we are certain that an overflow will not occur
  function Add(uint256 _a, uint256 _b) internal pure returns (uint256) {
    return _a + _b;
  }

  function CheckIsZeroAddress(address _address) internal pure returns (bool) {
    if (_address == address(0)) revert ZeroAddress();
    return true;
  }

  function MustGreaterThanZero(uint256 _value) internal pure returns (bool result) {
    assembly {
      // The 'iszero' opcode returns 1 if the input is zero, and 0 otherwise.
      // So, 'iszero(iszero(_value))' returns 1 if value > 0, and 0 if value == 0.
      result := iszero(iszero(_value))
    }
  }
}
