import * as dotenv from "dotenv";

import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";

dotenv.config();


const API_KEY: string | undefined= process.env.API_KEY;
const PRIVATE_KEY: string | undefined = process.env.PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      chainId: 1337
    },
    mumbai: {
      url : `https://polygon-mumbai.g.alchemy.com/v2/${API_KEY}`,
      accounts: [PRIVATE_KEY!]
    },

  }
};

export default config;
