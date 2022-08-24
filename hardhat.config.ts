import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
import "hardhat-gas-reporter";

const config: HardhatUserConfig = {
	solidity: "0.8.9",
	gasReporter: {
		currency: 'USD',
		gasPrice: 50,
		enabled: !!process.env.REPORT_GAS,
		coinmarketcap: process.env.COINMARKETCAP_API_KEY,
		maxMethodDiff: 10,
	  },

};



export default config;
