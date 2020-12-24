// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.4.21;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 */

library SafeMath {
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

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   * Counterpart to Solidity's `*` operator.
   * Hardening: Multiplication cannot overflow.
   */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (_a == 0) {
      return 0;
    }

    uint256 c = _a * _b;
    /* overflow check */
    require(c / _a == _b);

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   * Hardening: The divisor cannot be zero.
   */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    /* divisor cannot be zero */
    require(_b > 0);
    uint256 c = _a / _b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   * Hardening: The divisor cannot be zero.
   */
  function mod(uint256 _a, uint256 _b) internal pure returns (uint256) {
    /* divisor cannot be zero */
    require(_b != 0);
    return _a % _b;
  }
    
}
