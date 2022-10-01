//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @dev 空投合约
 *
 */
contract Airdrop is Ownable {

    /**
     * @dev 批量空头代币
     *
     */
    function airdrop(
        address[] calldata to,
        uint256[] calldata amounts,
        address tokenAddress
    ) public onlyOwner  {
        // 判断此合约的授权额度是否足够
        IERC20 token = IERC20(tokenAddress);
        require(token.allowance(msg.sender, address(this))>= getSum(amounts), "insufficient balance!!");
        require(to.length == amounts.length, "params error!!");
        for (uint i = 0; i < to.length; i++) {
            // 这次call的caller是Airdrop合约，但是gas fee是由调用Airdrop的用户出
            token.transferFrom(msg.sender, to[i], amounts[i]);
        }
    }

    /**
     * @dev 获取需要空投的代币总额
     * 
     */
    function getSum(uint256[] calldata amounts) internal pure returns(uint256 sum) {
        for (uint256 i = 0; i < amounts.length; i++) {
            sum += amounts[0];
        }
    }

    modifier beforeAirdrop(address tokenAddress, uint256 amount) {
        IERC20 token = IERC20(tokenAddress);
        require(
            token.balanceOf(address(this)) >= amount,
            "insufficient offer!"
        );
        _;
    }
}
