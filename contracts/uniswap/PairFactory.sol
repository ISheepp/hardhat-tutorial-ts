//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Pair.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// 工厂合约
contract PairFactory is Ownable {
    mapping(address => mapping(address => address)) public tokenPairMap;
    address[] public pairs;

    function addPair(address _tokenA, address _tokenB)
        public
        returns (address)
    {
        Pair pair = new Pair();
        pair.init(_tokenA, _tokenB);
        address pairAddress = address(pair);
        pairs.push(pairAddress);
        tokenPairMap[_tokenA][_tokenB] = pairAddress;
        tokenPairMap[_tokenB][_tokenA] = pairAddress;
        return pairAddress;
    }

    /**
     * @dev 使用 CREATE2 创建合约
     */
    function usecreate2(address _tokenA, address _tokenB)
        external
        returns (address)
    {
        require(_tokenA != _tokenB, "identical address !");
        // 排序
        (address token0, address token1) = _tokenA < _tokenB
            ? (_tokenA, _tokenB)
            : (_tokenB, _tokenA);
        // 计算 salt
        bytes32 _salt = keccak256(abi.encodePacked(token0, token1));
        Pair pair = new Pair{salt: _salt}();
        pair.init(_tokenA, _tokenB);
        address pairAddress = address(pair);
        pairs.push(pairAddress);
        tokenPairMap[_tokenA][_tokenB] = pairAddress;
        tokenPairMap[_tokenB][_tokenA] = pairAddress;
        return pairAddress;
    }

    /**
     * @dev 提前计算好新合约的地址, 实际上salt可以是任意的
     */
    function calculateAddr(address tokenA, address tokenB)
        public
        view
        returns (address predictedAddress)
    {
        require(tokenA != tokenB, "IDENTICAL_ADDRESSES"); //避免tokenA和tokenB相同产生的冲突
        // 计算用tokenA和tokenB地址计算salt
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA); // 将tokenA和tokenB按大小排序
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        // 计算合约地址方法 hash()
        predictedAddress = address(
            uint160(
                uint(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xff),
                            address(this),
                            salt,
                            keccak256(type(Pair).creationCode)
                        )
                    )
                )
            )
        );
    }

    /**
     * @dev delete contract 
     * selfdestruct(_addr)
     * _addr 是接收合约剩余的ETH
     */
    function deleteThisContract() external onlyOwner {
        selfdestruct(payable(msg.sender));
    }
}
