// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.4.20;

import "./interfaces/IECRC20.sol";
import "./interfaces/ImToken.sol";
import "./libs/MiniSafeMath.sol";

contract ProxyOracleSystem {
  /* oracle system validates if everything is ok */
  function validateAction(uint256 signature) external returns (bool valid);
}

contract mToken is IECRC20, ImToken {
  using MiniSafeMath for uint256;

  ProxyOracleSystem _proxyContract_;
  mapping (address => uint256) private balances_;
  mapping (address => mapping (address => uint256)) private allowances_;

  string private name_;
  string private symbol_;
  uint8 private decimals_;
  uint256 private totalSupply_;
  address private proxySystem_;

  /*
   * @notice constructor
   * @param _name 
   * @param _symbol
   * @param _decimals
   * @param _proxy_oracle_system - address of proxy smart contract
   */
  function mToken(string _name, string _symbol, uint8 _decimals, address _proxy_oracle_system) public {
    name_ = _name;
    symbol_ = _symbol;
    decimals_ = _decimals;
    totalSupply_ = 0;
    proxySystem_ = _proxy_oracle_system;
  }

  modifier validAction(uint256 _signature) {
    require(_proxyContract_.validateAction(_signature));
    _;
  }

  /*
   * @notice returns the description of the token.
   * Should start with "Mirrored"
   * @return string 
   */
  function name() public view returns (string memory) {
    return name_;
  }

  /*
   * @notice returns the symbol of the token.
   * Should start with "M"
   * @return string - the symbol 
   */ 
  function symbol() public view returns (string memory) {
    return symbol_;
  }

  /*
   * @notice returns the precision
   * @return uint8
   */
  function decimals() external view returns (uint8) {
    return decimals_;
  }

  /*
   * @notice returns the totalSupply
   * supply is not fixed. It starts with 0 and should never exceed
   * total supply of the original token
   * @return uint256
   */
  function totalSupply() external view returns (uint256) {
    return totalSupply_;
  }

  /*
   * @notice returns the token balance of a beneficiar
   * @param _account - beneficiar's address
   * @return uint256
   */
  function balanceOf(address _account) external view returns (uint256) {
    return balances_[_account];
  }

  /*
   * @notice direct transfer of tokens
   * @param _recipient - beneficiar's address
   * @param _amount - amount to be transfered
   * @return uint256
   */

  function transfer(address _recipient, uint256 _amount) external returns (bool) {
    _transfer(_msgSender(), _recipient, _amount);
    return true;
  }

  /*
   * @notice token transfer by authorized entity
   * @param _sender - sender's address
   * @param _recipient - beneficiar's address
   * @param _amount - amount to be transfered
   * @return bool - must return true, as it is an  ERC20 demand
   */
  function transferFrom(address _sender, address _recipient, uint256 _amount) external returns (bool) {
    _transfer(_sender, _recipient, _amount);
    _approve(_sender, _msgSender(), allowances_[_sender][_msgSender()].sub(_amount));
    return true;
  }

  /*
   * @notice display how many tokens a third party can spend in behalf of the owner
   * @param _owner - owner's address
   * @param _spender - address of authorized third party
   * @return uint256 - total authorized amount
   */
  function allowance(address _owner, address _spender) external view returns (uint256) {
    return allowances_[_owner][_spender];
  }

  /*
   * @notice allow an entity to spend tokens in behalf of the beneficiar
   * @param _spender - beneficiar's address
   * @param _amount - amount to be transfered
   * @return bool - must return true
   */
  function approve(address _spender, uint256 _amount) external returns (bool) {
    _approve(_msgSender(), _spender, _amount);
    return true;
  }

 /*
   * @notice increase the amount of allowed tokens to be spent
   * @param _spender - beneficiar's address
   * @param _addedValue - amount to be transfered
   * @return bool - must return true
   */

  function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
    _approve(_msgSender(), _spender, allowances_[_msgSender()][_spender].add(_addedValue));
    return true;
  }

  /*
   * @notice decrease the amount of allowed tokens to be spent
   * @param _spender - beneficiar's address
   * @param _subtractedValue - amount to be transfered
   * @return bool - must return true
   */
  function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
    _approve(_msgSender(), _spender, allowances_[_msgSender()][_spender].sub(_subtractedValue));
    return true;
  }

  /*
   * @notice transfer of tokens , internal function
   * @param _sender - sender's address
   * @param _recipient - beneficiar's address
   * @param _amount - amount to be transfered
   * @info - emits Transfer() event
   */

  function _transfer(address _sender, address _recipient, uint256 _amount) internal {
    require(_sender != address(0));
    require(_recipient != address(0));

    balances_[_sender] = balances_[_sender].sub(_amount);
    balances_[_recipient] = balances_[_recipient].add(_amount);
    emit Transfer(_sender, _recipient, _amount);
  }

  /*
   * @notice authorize third part to make payments, internal function
   * @param _owner - owner's address
   * @param _spender - spemder's address
   * @param _amount - amount to be transfered
   * @info - emits Approval() event
   */

  function _approve(address _owner, address _spender, uint256 _amount) internal {
    require(_owner != address(0));
    require(_spender != address(0));

    allowances_[_owner][_spender] = _amount;
    emit Approval(_owner, _spender, _amount);
  }

  /*
   * @notice issue new tokens, must equal to locked token on original chain
   * @param _to - beneficiar's address
   * @param _amount - amount to be issued
   * @param _signature - must be validated first to issue the tokens
   * @info - emits Issued() event
   */

  function issue(address _to, uint256 _amount, uint256 _signature) external
    validAction(_signature) {
    balances_[_to].add(_amount);
    totalSupply_.add(_amount);
    emit Issued(_to, _amount);
  }

  /*
   * @notice destroy tokens, must equal to unlocked tokens on original chain
   * @param _from - owner's address
   * @param _amount - amount to be burned
   * @param _signature - must be validated first before burning the tokens
   * @info - emits Vurned() event
   */
  function burn(address _from, uint256 _amount, uint256 _signature) external
    validAction(_signature) {
    balances_[_from].sub(_amount);
    totalSupply_.sub(_amount);
    emit Burned(_from, _amount);
  }

  /*
   * @notice return the caller's address , internal function
   * @return address - caller's address
   */
  function _msgSender() internal view returns (address) {
    return msg.sender;
  }

  /*
   * @notice return the transaction's data , internal function
   * @return address - transaction's data
   */
  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}
