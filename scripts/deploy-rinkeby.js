// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { Wallet } = require("ethers");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const wbtcAbi = require("./utils/wbtc.json");
const wethAbi = require("./utils/weth.json");
const uniAbi = require("./utils/uni.json");

const provider = new ethers.providers.JsonRpcProvider("https://eth-rinkeby.alchemyapi.io/v2/51OAkh_Ylwdz5-XPnWfGn9-DF0kkrl5-");
const wallet = new ethers.Wallet("ffd569bc97f8d6cfb04a3a17ba634d14ae07e5bbd669ac9f0a334c753c9662c2", provider);

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Optimizer = await hre.ethers.getContractFactory("OptimizerDAO");
  const optimizer = await Optimizer.deploy();

  await optimizer.deployed("ffd569bc97f8d6cfb04a3a17ba634d14ae07e5bbd669ac9f0a334c753c9662c2");


  console.log("OptimizerDAO deployed to:", optimizer.address);

  //const join = await optimizer.joinDAO({ value: ethers.utils.parseEther("0.2") });

  /// sBAT

  // const Bat = await hre.ethers.getContractFactory("ShortBat");
  // const bat = await Bat.deploy();

  // await bat.deployed("ffd569bc97f8d6cfb04a3a17ba634d14ae07e5bbd669ac9f0a334c753c9662c2");


  // console.log("sBAT deployed to:", bat.address);
  // ///sBTC

  // const Btc = await hre.ethers.getContractFactory("ShortBtc");
  // const btc = await Btc.deploy();

  // await btc.deployed("ffd569bc97f8d6cfb04a3a17ba634d14ae07e5bbd669ac9f0a334c753c9662c2");


  // console.log("sBTC deployed to:", btc.address);
  // /// sUNI

  // const Uni = await hre.ethers.getContractFactory("ShortUni");
  // const uni = await Uni.deploy();

  // await uni.deployed("ffd569bc97f8d6cfb04a3a17ba634d14ae07e5bbd669ac9f0a334c753c9662c2");


  // console.log("sUNI deployed to:", uni.address);

  // /// sUSDT

  // const Usd = await hre.ethers.getContractFactory("ShortUsd");
  // const usd = await Usd.deploy();

  // await usd.deployed("ffd569bc97f8d6cfb04a3a17ba634d14ae07e5bbd669ac9f0a334c753c9662c2");


  // console.log("sUSD deployed to:", usd.address);

  // /// sETH

  // const Eth = await hre.ethers.getContractFactory("ShortEth");
  // const eth = await Eth.deploy();

  // await eth.deployed("ffd569bc97f8d6cfb04a3a17ba634d14ae07e5bbd669ac9f0a334c753c9662c2");


  // console.log("sETH deployed to:", eth.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
