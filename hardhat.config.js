require('@nomiclabs/hardhat-waffle');
require('dotenv').config({path:__dirname+'/.env'})
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: {
    version: "0.8.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/51OAkh_Ylwdz5-XPnWfGn9-DF0kkrl5-",
      accounts: [`${process.env.RINKEBY_PRIVATE_KEY}`],
    },
    hardhat: {
      forking: {
        url: "https://eth-rinkeby.alchemyapi.io/v2/51OAkh_Ylwdz5-XPnWfGn9-DF0kkrl5-",
        chainId: 31337,
      }
    }
  },
  etherscan: {
    apiKey:"WMTJWYVUG9RUZZ2RWC2YFB5A2UD426I9X9"
  }
};
