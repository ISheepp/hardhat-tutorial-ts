//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// 逻辑合约
contract Logic {

    uint256 public num;
    address public sender;

    /**
     * @dev 设置变量
     */
    function setVariable(uint256 _num, address _sender) public {
        num = _num;
        sender = _sender;
    }
}