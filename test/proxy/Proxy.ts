import { ethers } from "hardhat"
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers"
import { expect } from "chai";

describe("测试代理合约", async () => {
    async function deployContract() {
        const [owner, otherAccount] = await ethers.getSigners();
        const proxyFactory = await ethers.getContractFactory("Proxy");
        const proxyContract = await proxyFactory.deploy();
        const logicFactory = await ethers.getContractFactory("Logic");
        const logicContract = await logicFactory.deploy();
        return { proxyContract, logicContract, owner, otherAccount };
    }

    it("测试call", async () => {
        const { proxyContract, logicContract, owner, otherAccount } = await loadFixture(deployContract);
        const logicContractAddress = logicContract.address;
        const receipt = await proxyContract.callContract(logicContractAddress, 12, otherAccount.address);
        await receipt.wait();
        expect(await logicContract.num()).to.equals(12);
        expect(await logicContract.sender()).to.equals(otherAccount.address);
    })
})