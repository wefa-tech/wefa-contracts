import { NetworksUserConfig } from "hardhat/types"
import { HardhatUserConfig } from "hardhat/config"
import { config as dotenvConfig } from "dotenv"
import { resolve } from "path"

import { config } from "./package.json"

import "@nomicfoundation/hardhat-toolbox"
import "solidity-coverage"

dotenvConfig({ path: resolve(__dirname, "./.env") })

function getNetworks(): NetworksUserConfig | undefined {
  if (process.env.INFURA_API_KEY && process.env.BACKEND_PRIVATE_KEY) {
    const infuraApiKey = process.env.INFURA_API_KEY
    const accounts = [`0x${process.env.BACKEND_PRIVATE_KEY}`]

    return {
      goerli: {
        url: `https://goerli.infura.io/v3/${infuraApiKey}`,
        chainId: 5,
        accounts
      },
      optimism_goerli: {
        url: `https://optimism-goerli.infura.io/v3/${infuraApiKey}`,
        chainId: 420,
        accounts
      },
      arbitrum_goerli: {
        url: `https://arbitrum-goerli.infura.io/v3/${infuraApiKey}`,
        chainId: 421613,
        accounts
      },
      arbitrum: {
        url: `https://arbitrum-mainnet.infura.io/v3/${infuraApiKey}`,
        chainId: 42161,
        accounts
      },
      optimism: {
        url: `https://optimism-mainnet.infura.io/v3/827${infuraApiKey}`,
        chainId: 10,
        accounts
      },
      // starknet: {
      //   url: `https://starknet-mainnet.infura.io/v3/${infuraApiKey}`,
      //   chainId: 5,
      //   accounts
      // },
      mainnet: {
        url: `https://mainnet.infura.io/v3/${infuraApiKey}`,
        chainId: 1,
        accounts
      }
    }
  }
}

const hardhatConfig: HardhatUserConfig = {
  solidity: config.solidity,
  paths: {
    sources: config.paths.contracts,
    tests: config.paths.tests,
    cache: config.paths.cache,
    artifacts: config.paths.build.contracts
  },
  networks: {
    hardhat: {
      chainId: 1337,
      allowUnlimitedContractSize: true
    },
    ...getNetworks()
  },
  gasReporter: {
    currency: "USD",
    enabled: process.env.REPORT_GAS === "true",
    coinmarketcap: process.env.COINMARKETCAP_API_KEY
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  },
  typechain: {
    outDir: config.paths.build.typechain,
    target: "ethers-v5",
    alwaysGenerateOverloads: false, // should overloads with full signatures like deposit(uint256) be generated always, even if there are no overloads?
    externalArtifacts: ["externalArtifacts/*.json"] // optional array of glob patterns with external artifacts to process (for example external libs from node_modules)
  },
  mocha: {
    parallel: true
  }
}

export default hardhatConfig
