// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.4.21;

/**
 * @dev Wrappers over Solidity's operations `+` and `-` , with added 
 * overflow/underflow checks.
 * This mini library targets smart contracts that need only 
 * plus and minus operations
 */

library MiniSafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   * Counterpart to Solidity's `+` operator.
   * Hardening: Addition cannot overflow.
   */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
    uint256 c = _a + _b;
    /* overflow check */
    require(c >= _a);

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * underflow (when the result is negative).
   * Counterpart to Solidity's `-` operator.
   * Hardening: Subtraction cannot underflow
   */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    /* underflow check */
    require(_b <= _a);
    uint256 c = _a - _b;

    return c;
  }
  
}
