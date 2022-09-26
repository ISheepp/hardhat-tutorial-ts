//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// 币对合约
contract Pair {
    address public factory;
    address public tokenA;
    address public tokenB;

    constructor() {
        factory = msg.sender;
    }

    function init(address _tokenA, address _tokenB) public {
        require(factory == msg.sender, "caller must be factory!");
        tokenA = _tokenA;
        tokenB = _tokenB;
    }
}