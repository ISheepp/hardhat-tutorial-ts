import { ethers } from "hardhat"
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers"
import { expect } from "chai";

describe("测试逻辑合约",async () => {
    async function deployContract() {
        const [owner, otherAccount] = await ethers.getSigners();
        const factory = await ethers.getContractFactory("Logic");
        const contract = await factory.deploy();
        return {contract, owner, otherAccount};
    }

    it("测试函数set",async () => {
        const {contract, owner, otherAccount} = await loadFixture(deployContract);
        const receipt = await contract.setVariable(12, otherAccount.address)
        await receipt.wait();
        expect(await contract.num()).to.equal(12);
        expect(await contract.sender()).to.equal(otherAccount.address);
    })
})