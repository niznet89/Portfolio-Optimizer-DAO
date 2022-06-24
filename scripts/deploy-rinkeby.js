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

const provider = new ethers.providers.JsonRpcProvider("http://127.0.https://eth-rinkeby.alchemyapi.io/v2/51OAkh_Ylwdz5-XPnWfGn9-DF0kkrl5-.1:8545/");
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

  const join = await optimizer.joinDAO({ value: ethers.utils.parseEther("0.2") });





  // const weth = "0xc778417E063141139Fce010982780140Aa0cD5Ab";

  // const contract1 = new ethers.Contract(weth, wethAbi, wallet);

  // console.log("in the way");

  // let walletEth = await contract1.balanceOf(optimizer.address);

  // console.log(walletEth);

  ////
  // const sendUni = await optimizer.initiateTradesOnUniswap(["BAT", "WBTC", "UNI", "USDT"], [25,25,25,25]);
  // const reciept = await sendUni.wait();


  // //console.log(reciept);
  // const wbtc = "0x0014F450B8Ae7708593F4A46F8fa6E5D50620F96";

  // const contract = new ethers.Contract(wbtc, wbtcAbi, wallet);

  // let walletBtc = await contract.balanceOf(optimizer.address);

  // const uni = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";

  // const uniContract = new ethers.Contract(uni, uniAbi, wallet);

  // let walletUni = await contract.balanceOf(optimizer.address);



  // console.log(`balance of WBTC:${walletBtc}`);
  // console.log(`balance of UNI:${walletUni}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
