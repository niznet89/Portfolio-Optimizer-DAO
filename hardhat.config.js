require('@nomiclabs/hardhat-waffle');
require('dotenv').config();
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: "https://eth-rinkeby.alchemyapi.io/v2/51OAkh_Ylwdz5-XPnWfGn9-DF0kkrl5-",
      accounts: [`0x${process.env.RINKEBY_PRIVATE_KEY}`],
    },
    hardhat: {
      forking: {
        url: "https://eth-rinkeby.alchemyapi.io/v2/51OAkh_Ylwdz5-XPnWfGn9-DF0kkrl5-",
      }
    }
  },
  etherscan: {
    apiKey:"WMTJWYVUG9RUZZ2RWC2YFB5A2UD426I9X9"
  }
};
