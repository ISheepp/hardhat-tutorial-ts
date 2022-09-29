//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// try catch 只能用于external函数或者构造函数
contract TryCatch {
    event Success(bool);
    event Fail();
    event FailReason(string reason);
    event FailReasonBytes(bytes reason);
    OnlyEven private even;

    constructor(uint256 a) {
        even = new OnlyEven(a);
    }

    function createEven() external {
        try new OnlyEven(1) returns (OnlyEven only) {
            only.onlyEven(3);
        } catch (bytes memory reason) {
            emit FailReasonBytes(reason);
        }
    }

    function execute(uint256 a) external {
        try even.onlyEven(a) returns (bool result) {
            emit Success(result);
        } catch Error(string memory reason) {
            emit Fail();
            emit FailReason(reason);
        }
    }
}

contract OnlyEven {
    constructor(uint256 _num) {
        require(_num != 0, "ops! reverting");
        assert(_num != 1);
    }

    /**
     * @dev 当输入奇数时，revert
     */
    function onlyEven(uint256 b) external pure returns (bool) {
        require(b % 2 == 0, "param is odd!!!");
        return true;
    }
}
