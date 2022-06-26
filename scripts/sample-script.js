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

const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545/");
const wallet = new ethers.Wallet("0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e", provider);

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

  await optimizer.deployed("0xdf57089febbacf7ba0bc227dafbffa9fc08a93fdc68e1e42411a14efcf23656e");


  console.log("OptimizerDAO deployed to:", optimizer.address);

  const join = await optimizer.joinDAO({ value: ethers.utils.parseEther("10") });





  const weth = "0xc778417E063141139Fce010982780140Aa0cD5Ab";

  const contract1 = new ethers.Contract(weth, wethAbi, wallet);

  console.log("in the way");

  let walletEth = await contract1.balanceOf(optimizer.address);

  console.log(walletEth);

  ////
  const sendUni = await optimizer.initiateTradesOnUniswap(["WETH", "BAT", "WBTC", "UNI", "USDT", "sWETH", "sBAT", "sWBTC", "sUNI", "sUSDT"], [10,10,10,10,10,10,10,10,10,10]);
  const reciept = await sendUni.wait();


  //console.log(reciept);
  const wbtc = "0x0014F450B8Ae7708593F4A46F8fa6E5D50620F96";

  const contract = new ethers.Contract(wbtc, wbtcAbi, wallet);

  let walletBtc = await contract.balanceOf(optimizer.address);

  const uni = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";

  const uniContract = new ethers.Contract(uni, uniAbi, wallet);

  let walletUni = await contract.balanceOf(optimizer.address);

  const sendUni2 = await optimizer.initiateTradesOnUniswap(["WETH", "BAT", "WBTC", "UNI", "USDT", "sWETH", "sBAT", "sWBTC", "sUNI", "sUSDT"], [10,10,10,10,10,0,0,0,0,0]);

  //console.log(sendUni2);

  const proposals = await optimizer.lengthOfProposals();

  console.log("Length of proposals:", proposals);

  const data = await optimizer.getHoldingsDataOfProposal(1);

  console.log(data);

  console.log(await optimizer.proposals(0));

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
