const { Wallet } = require("ethers");
const { ethers } = require("hardhat");
const hre = require("hardhat");
const wbtcAbi = require("./utils/wbtc.json");
const wethAbi = require("./utils/weth.json");
const uniAbi = require("./utils/uni.json");

const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545/");
const wallet = new ethers.Wallet("0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80", provider);

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Event = await hre.ethers.getContractFactory("EventNFT");
  const event = await Event.deploy();

  await event.deployed("0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80");


  console.log("EventNFT:", event.address);

  const result = await event.isCreator();
  //const tx = await result.wait();

  //console.log(event);

  // const join = await optimizer.joinDAO({ value: ethers.utils.parseEther("10") });






}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
