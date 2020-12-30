// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.4.20;

/**
 * @dev Interface of asset cross-chaining from other chains to ecochain
 */
interface IBridge {
  /*
   * @dev request locking of the original tokens. Callable by User
   * @param _ecoc_address - ecochain target address where the mirrored tokens must be issued
   * @param _amount - token amount for locking. An at least equal amount must be approved first(approve() of ERC20 standards)
   * @param _hashed_secret - the hash of the secrat that user has created
   */
  function requestLocking(string _ecoc_address, uint256 _amount, uint256 _hashed_secret) external payable;

  /*
   * @dev in case that lock period passed (that is, mirrored tokens haven't beed issued) the user can take back his tokens
   * @retun uint256 - amount of returning tokens 
   */
  function cancelLocking() external payable returns(uint256 amount);
  
  /*
   * @dev request a mirrored token request burning for a user. Callable by Oracles
   * Oracles copies and gets necessary function arguments by checking requestLocking() on original chain (ETH)
   * @param _to - address to return the original tokens. Must be the same that passed at requestBurning()
   * @param _amount - token amount. Must be equal to the requested burning amount on ecochain
   * @param _hashed_secret - copied from requestBurning()
   * @param _ecoc_tx - transction hash of requestBurning()
   */
  function initUnlock(address _to, uint256 _amount, uint256 _hashed_secret, string _ecoc_tx) external; 

  /*
   * @dev lock the original tokens. Callable by Oracles
   * @param _secret - plain secret
   * @param _ecoc_tx - transaction hash of issue()
   * @retun uint256 - amount of unlocked tokens 
   */

  function lock(uint256 _secret, string _ecoc_tx) external returns(uint256 amount);

  /*
   * @dev unlock the original tokens. Callable by User
   * @param _secret - plain secret
   * @param _ecoc_tx - transaction hash of requestBurning()
   * @retun uint256 - amount of unlocked tokens 
   */

  function unlock(uint256 _secret, string _ecoc_tx) external returns(uint256 amount);

  /* events */
  event RequestLockingEvent(string ecoc_address, uint256 amount, uint256 hashed_secret);
  event CancelLockingEvent(address user, uint256 amount);
  event InitUnlockEvent(address _to, uint256 amount, uint256 hashed_secret, string tx_ecoc);
  event LockEvent(address user, uint256 amount, uint256 secret, string tx_ecoc);
  event UnlockEvent(address user, uint256 amount, uint256 secret, string tx_ecoc);
			
}
