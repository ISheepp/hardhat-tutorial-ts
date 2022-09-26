import "dotenv/config";
import { HardhatUserConfig } from "hardhat/types";

import "@nomicfoundation/hardhat-toolbox";
import "@typechain/hardhat";
import "@nomiclabs/hardhat-ethers";
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-etherscan";
import { ProxyAgent, setGlobalDispatcher } from "undici"
const proxyAgent = new ProxyAgent('http://127.0.0.1:1080'); // change to yours
setGlobalDispatcher(proxyAgent);


const GOERLI_URL = process.env.GOERLI_URL;
const MUMBAI_URL = process.env.MUMBAI_URL;
const PRIVATE_KEY = <string>process.env.PRIVATE_KEY;
const ENABLED = process.env.REPORT_GAS;
const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

const config: HardhatUserConfig = {
    solidity: {
        version: "0.8.9",
        settings: {
            optimizer: {
                enabled: false,
                runs: 200,
            },
        }
    },
    networks: {
        goerli: {
            url: GOERLI_URL,
            accounts: [PRIVATE_KEY]
        },
        mumbai: {
            url: MUMBAI_URL,
            accounts: [PRIVATE_KEY]
        }
    },
    gasReporter: {
        currency: 'USD',
        gasPrice: 50,
        enabled: false,
        coinmarketcap: COINMARKETCAP_API_KEY,
        maxMethodDiff: 10,
    },
    etherscan: {
        // Your API key for Etherscan
        // Obtain one at https://etherscan.io/
        apiKey: ETHERSCAN_API_KEY
    }


};



export default config;
