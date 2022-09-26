//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat/console.sol";
// 代理合约
contract Proxy {

    uint256 public num;
    address public sender;

    /**
     * @dev 普通 call 调用
     */
    function callContract(address _addr, uint256 _num, address _sender) public {
        bytes memory data = abi.encodeWithSignature("setVariable(uint256, address)", _num, _sender);
        console.logBytes(data);
        (bool result, ) = _addr.call(data);
        require(result, "transaction failed!");
    }

    /**
     * @dev 委托 call 调用
     */
    function delegateCallContract(address _addr, uint256 _num, address _sender) public {
        bytes memory data = abi.encodeWithSignature("setVariable(uint256, address)", _num, _sender);
        console.logBytes(data);
        (bool result, ) = _addr.delegatecall(data);
        require(result, "transaction failed!");
    }

}