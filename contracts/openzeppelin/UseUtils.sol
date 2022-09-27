//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Context.sol";

contract UseUtils is Context {
    address public owner;

    event Response(string);

    function setOwner() external {
        owner = _msgSender();
        emit Response("success");
    }
}
