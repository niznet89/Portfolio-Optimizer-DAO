//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OptimizerDAO {
  // May be able to delete membersTokenCount as tally is taken care of in ERC contract
  mapping(address => uint) public membersTokenCount;
  address public LPTokenAddress;
  uint public tokenReserve;
  uint public treasuryEth;

  // Proposal struct of token, expected performance and confidence level.
  struct Proposal {
    uint date;
    mapping(string => uint) tokenCount;
    mapping(string => uint) performanceOfToken;
    mapping(string => uint) confidenceLevelofToken;
  }


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

  function submbitVote(string[] memory _token, int[] memory _perfOfToken, uint[] memory _confidenceLevels) public onlyMember {
    // User inputs token they'd like to vote on, the expected performance of token over time period and their confidence level
    // Loop through each token in list and provide a +1 on list
    // If token is in proposal, include in Struct and output average for Performance & confidence levels

  }

  function rebalance() public {
    // Function is hit by external source... Chainlink?
    //
  }

  modifier onlyMember {
      require(ERC20(LPTokenAddress).balanceOf(msg.sender) > 0);
      _;
   }

}
