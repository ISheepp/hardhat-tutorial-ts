//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 荷兰拍卖 NFT
contract DutchAuction is Ownable, ERC721 {
    // NFT 总供应量
    uint256 public constant NFT_COLLECTION_ALL = 10000;
    // 起拍价
    uint256 public constant AUCTION_START_VALUE = 1 ether;
    // 结束价
    uint256 public constant AUCTION_END_VALUE = 0.1 ether;
    // 拍卖持续时长
    uint256 public constant AUCTION_CONTINUE_TIME = 10 minutes;
    // 每次降价的时间
    uint256 public constant AUCTION_REDUCE_TIME = 1 minutes;
    // 每次降价多少
    uint256 public constant AUCTION_PER_VALUE =
        (AUCTION_START_VALUE - AUCTION_END_VALUE) /
            (AUCTION_CONTINUE_TIME / AUCTION_REDUCE_TIME);

    // 拍卖开始时间戳
    uint256 public auctionStartTime;
    // NFT baseURI
    string private _baseTokenURI;
    // 记录所有的tokenId
    uint256[] private _alltokenIds;

    constructor() ERC721("StarBuck NFT", "SBN") {
        auctionStartTime = block.timestamp;
    }

    /**
     * @dev 设定拍卖的开始时间
     * @param _timestamp 给定的时间戳
     */
    function setAuctionStartTime(uint256 _timestamp) external onlyOwner {
        auctionStartTime = _timestamp;
    }

    /**
     * @dev 根据当前时间和状态获取 NFT 的价格
     * @param _auctionStartTime 拍卖开始时间
     * @return 价格
     */
    function getAuctionPrice(uint256 _auctionStartTime)
        public
        view
        returns (uint256)
    {
        if (block.timestamp <= _auctionStartTime) {
            return AUCTION_START_VALUE;
        } else if (
            block.timestamp - _auctionStartTime >= AUCTION_CONTINUE_TIME
        ) {
            return AUCTION_END_VALUE;
        } else {
            // 时间单位都是用秒来计算
            uint256 step = (block.timestamp - _auctionStartTime) /
                AUCTION_REDUCE_TIME;
            return AUCTION_START_VALUE - step * AUCTION_PER_VALUE;
        }
    }

    /**
     * @dev 拍卖铸造NFT
     * @param quantity mint的数量
     */
    function auctionMint(uint256 quantity) external payable {
        // 创建local变量减少gas消耗
        uint256 _saleStartTime = uint256(auctionStartTime);
        require(
            _saleStartTime != 0 && block.timestamp >= _saleStartTime,
            "the auction has not started yet"
        );
        // 计算总成本
        uint256 allPrice = getAuctionPrice(_saleStartTime) * quantity;
        require(msg.value >= allPrice, "need to send more ETH!");
        // mint NFT
        for (uint i = 0; i < quantity; i++) {
            uint256 mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
            _alltokenIds.push(mintIndex);
        }
        // 多余的ETH退款
        if (msg.value - allPrice > 0) {
            (bool result, ) = payable(msg.sender).call{
                value: msg.value - allPrice
            }("");
            require(result, "transaction failed!!!");
        }
    }

    /**
     * @dev 获取当前NFT的总供应量
     */
    function totalSupply() public view virtual returns (uint256) {
        return _alltokenIds.length;
    }

    /**
     * @dev 提款函数
     * 
     */
    function withdraw() external onlyOwner {
        uint256 contractValue = address(this).balance;
        if (contractValue > 0) {
            (bool result, ) = payable(msg.sender).call{value: contractValue}(
                ""
            );
            require(result, "transaction failed!!!");
        }
    }
}
