// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.4.20;

/**
 * @dev Interface of asset cross-chaining to Ethereum
 */
interface IBridgeToEthereum {
  /*
   * @dev request a mirrored token issuance for a user. Callable by Oracles
   * Oracles copies and gets necessary function arguments by checking requestLocking() on original chain (ETH)
   * @param _issue_to - ecoc address to issue the mirrord tokens. Must be the same that passed at requestLocking()
   * @param _amount - token amount. Must be equal to the requested locked amount on the other chain
   * @param _hashed_secret - copied from requestLocking()
   * @param _eth_tx - transction hash of requestLocking()
   */
  function initIssuance(address _issue_to, uint256 _amount, uint256 _hashed_secret, uint256 _eth_tx) external payable;

  /*
   * @dev requst burning of mirrored tokens. Callable by User
   * @param _eth_address - ethereum target address where the tokens will be released (unlocked)
   * @param _amount - token amount for burning. Must be equal to the requested unlocked amount on the other chain
   * @param _hashed_secret - the hash of the secret that user has created
   */
  function requestBurning(string _eth_address, uint256 _amount, uint256 _hashed_secret) external payable;

  /* events */
  event InitIssuanceEvent(address _issue_to, uint256 _amount, uint256 _hashed_secret, uint256 _eth_tx);
  event RequestBurningEvent(string _eth_address, uint256 _amount, uint256 _hashed_secret);
}
