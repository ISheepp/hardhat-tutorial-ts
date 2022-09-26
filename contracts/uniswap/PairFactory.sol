//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Pair.sol";
// 工厂合约
contract PairFactory {
    mapping(address => mapping(address => address)) public tokenPairMap;
    address[] public pairs;

    function addPair(address _tokenA, address _tokenB) public returns(address) {
        Pair pair = new Pair();
        pair.init(_tokenA, _tokenB);
        address pairAddress = address(pair);
        pairs.push(pairAddress);
        tokenPairMap[_tokenA][_tokenB] = pairAddress;
        tokenPairMap[_tokenB][_tokenA] = pairAddress;
        return pairAddress;
    }
}
