#!/bin/sh

solc --optimize --evm-version byzantium --bin contracts/chains/ecochain/mToken.sol > build/mToken.bin.txt
solc --optimize --evm-version byzantium --abi contracts/chains/ecochain/mToken.sol > build/mToken.abi.txt

solc --optimize --evm-version byzantium --bin contracts/chains/ecochain/ProxyOracleSystem.sol > build/ProxyOracleSystem.bin.txt
solc --optimize --evm-version byzantium --abi contracts/chains/ecochain/ProxyOracleSystem.sol > build/ProxyOracleSystem.abi.txt

solc --optimize --evm-version byzantium --bin contracts/chains/ecochain/EthereumBridge.sol > build/EthereumBridge.bin.txt
solc --optimize --evm-version byzantium --abi contracts/chains/ecochain/EthereumBridge.sol > build/EthereumBridge.abi.txt
