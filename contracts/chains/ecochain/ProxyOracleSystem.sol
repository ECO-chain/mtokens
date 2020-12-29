contract OracleSystem{
  function validateAction(uint256 signature) external returns (bool valid);
}

contract ProxyOracleSystem{

  address admin_;
  OracleSystem _OS_;

  /*
   * @notice constructor
   * @param _OracleSystem_addr - address of the actual oracle protocol
   */
  function ProxyOracleSystem(address _OracleSystem_addr) {
    admin_ = msg.sender;
    _OS_ = OracleSystem(_OracleSystem_addr);
  }

  /*
   * @notice oracle system validates if everything is ok
   * @param _signature - data to check for validity from oracle system
   */
  function validateAction(uint256 _signature) external returns (bool valid) {
    return _OS_.validateAction(_signature);
  }

  /*
   * @notice update the address of the contract of oracle protocol
   * @param _OracleSystem_addr - new address of the actual oracle protocol
   */
  function updateOracleProtocol(address _new_addr) {
    assert(admin_ == msg.sender);

    _OS_ = OracleSystem(_new_addr);

  }
}
