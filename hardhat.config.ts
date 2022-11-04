import { NetworksUserConfig } from "hardhat/types"
import { HardhatUserConfig } from "hardhat/config"
import { resolve } from "path"

import { config } from "./package.json"

import "@nomicfoundation/hardhat-toolbox"
import "@matterlabs/hardhat-zksync-deploy"
import "@matterlabs/hardhat-zksync-solc"
import "solidity-coverage"

// eslint-disable-next-line @typescript-eslint/no-var-requires
require("dotenv").config({ path: resolve(__dirname, "/.env") })

function getNetworks(): NetworksUserConfig | undefined {
  if (process.env.INFURA_API_KEY && process.env.BACKEND_PRIVATE_KEY) {
    const infuraApiKey = process.env.INFURA_API_KEY
    const accounts = [`0x${process.env.BACKEND_PRIVATE_KEY}`]

    return {
      optimism_goerli: {
        url: `https://optimism-goerli.infura.io/v3/${infuraApiKey}`,
        chainId: 420,
        accounts,
        zksync: false
      },
      arbitrum_goerli: {
        url: `https://arbitrum-goerli.infura.io/v3/${infuraApiKey}`,
        chainId: 421613,
        accounts,
        zksync: false
      },
      goerli: {
        url: `https://goerli.infura.io/v3/${infuraApiKey}`,
        chainId: 5,
        accounts,
        zksync: false
      },
      optimism: {
        url: `https://optimism-mainnet.infura.io/v3/827${infuraApiKey}`,
        chainId: 10,
        accounts,
        zksync: false
      },
      arbitrum: {
        url: `https://arbitrum-mainnet.infura.io/v3/${infuraApiKey}`,
        chainId: 42161,
        accounts,
        zksync: false
      },
      mainnet: {
        url: `https://mainnet.infura.io/v3/${infuraApiKey}`,
        chainId: 1,
        accounts,
        zksync: false
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
      allowUnlimitedContractSize: true,
      zksync: true
    },
    ...getNetworks()
  },
  zksolc: {
    version: "1.2.0",
    compilerSource: "docker",
    settings: {
      optimizer: {
        enabled: true
      },
      experimental: {
        dockerImage: "matterlabs/zksolc",
        tag: "v1.2.0"
      }
    }
  },
  zkSyncDeploy: {
    zkSyncNetwork: "https://zksync2-testnet.zksync.dev",
    ethNetwork: "goerli" // Can also be the RPC URL of the network (e.g. `https://goerli.infura.io/v3/<API_KEY>`)
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
