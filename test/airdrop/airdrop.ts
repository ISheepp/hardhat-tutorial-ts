import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("测试空投代币", async () => {
    // 部署合约
    const deployERC20 = async () => {
        return await deploy("Coin");
    }

    // 部署空投合约
    const deployAirdrop = async () => {
        return await deploy("Airdrop");
    }

    const deploy = async (sol: string) => {
        const [owner, otherAccount1, otherAccount2] = await ethers.getSigners();
        // console.log(owner.address, "one: ", otherAccount1.address, "two:", otherAccount2.address);
        const factory = await ethers.getContractFactory(sol);
        const contract = await factory.deploy();
        return { contract, owner, otherAccount1, otherAccount2 };
    }

    it("测试mint", async () => {
        const { contract: token, owner, otherAccount1, otherAccount2 } = await loadFixture(deployERC20);
        const { contract: airdrop, owner: airdropOwner } = await loadFixture(deployAirdrop);

        expect(await token.connect(owner).mint(airdrop.address, ethers.utils.parseUnits("1000", 18)))
            .to
            .emit(token, "Transfer")
            .withArgs(ethers.constants.AddressZero, airdrop.address, ethers.utils.parseUnits("1000", 18));

        // owner 发空投, 发两个人， 每人1000
        await token.connect(owner).approve(airdrop.address, ethers.utils.parseUnits("2000", 18));
        const addressArray = [otherAccount1.address, otherAccount2.address];
        const amountArray = [ethers.utils.parseUnits("1000", 18), ethers.utils.parseUnits("1000", 18)];
        await airdrop.connect(owner).airdrop(addressArray, amountArray, token.address);
        // 测试结果
        expect(await token.balanceOf(otherAccount1.address)).to.equals(ethers.utils.parseUnits("1000", 18));
        expect(await token.balanceOf(otherAccount2.address)).to.equals(ethers.utils.parseUnits("1000", 18));
        expect(await token.balanceOf(owner.address)).to.equals(ethers.utils.parseUnits("8000", 18));
        expect(await token.allowance(owner.address, airdrop.address)).to.equals(0);

    })

})