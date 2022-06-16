//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OptimizerDAO {
  mapping(address => uint) public membersTokenCount;
  address public LPTokenAddress;
  uint public tokenReserve;
  uint public treasuryEth;


  constructor(address _LPTokenAddress) {
    LPTokenAddress = _LPTokenAddress;
  }

  function joinDAO() public payable {
    // What is the minimum buy in for the DAO?
    require(msg.value > 1 ether);
    if (treasuryEth == 0) {
      // If there is nothing in the treasury, provide liquidity to treasury
      // LP tokens are initially provided on a 1:1 basis
      uint liquidity = msg.value;
      treasuryEth = msg.value;
      ERC20(LPTokenAddress).transferFrom(address(this), msg.sender, liquidity);
    } else {
      tokenReserve = ERC20(LPTokenAddress).totalSupply() - ERC20(LPTokenAddress).balanceOf(address(this));
      // DAO members token count is diluted as more members join / add Eth
      uint proportionOfTokens = (msg.value * tokenReserve) / treasuryEth;
      tokenReserve += msg.value;
      ERC20(LPTokenAddress).transferFrom(address(this), msg.sender, proportionOfTokens);
    }
  }



}
