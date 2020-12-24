// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.4.20;

/**
 * @dev Interface of the mToken standard
 */
interface ImToken {

  /**
   * @dev signature is used to call the oracle system and check if 
   * the issuance is authorized
   */ 
  function issue(address _to, uint256 _amount, uint256 signature) external;
  
  /**
   * @dev signature is used to call the oracle system and check if 
   * the burning is authorized
   */
  function burn(address _from, uint256 _amount, uint256 signature) external;
  
  /**
   * @dev Emitted when successfully new tokens are iddued
   */
  event Issued(address _to, uint256 _amount);

  /**
   * @dev Emitted when successfully new tokens are burned
   */
  event Burned(address _from, uint256 _amount);
}
