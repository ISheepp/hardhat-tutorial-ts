import { ethers } from "hardhat"
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";

describe("测试Context", async () => {
    const deploy = async () => {
        const [owner] = await ethers.getSigners();
        const factory = await ethers.getContractFactory("UseUtils");
        const contract = await factory.deploy();
        return {contract, owner};
    }

    it("测试",async () => {
        const {contract, owner} = await loadFixture(deploy);
        const receipt = await contract.setOwner();
        await receipt.wait();
        expect(await contract.owner()).to.equal(owner.address);
    })
    
})