//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenSwap.sol";

contract OptimizerDAO is tokenSwap, ERC20 {
  // May be able to delete membersTokenCount as tally is taken care of in ERC contract
  uint public treasuryEth;

  //
  mapping(string => uint) public assetWeightings;

  // Proposal struct of token, expected performance and confidence level.
  struct Proposal {
    uint date;
    string[] tokens;
    // Maps Token (i.e 'btc') to array
    mapping(string => uint[]) numOfUserTokens;
    // Maps Token string to array of total token amount
    mapping(string => uint[]) userWeightings;
    mapping(string => uint[]) userConfidenceLevel;
    mapping(string => uint) proposalFinalPerformance;
    mapping(string => uint) proposalFinalConfidence;
  }

  // Array of Proposals
  Proposal[] public proposals;


  constructor() ERC20("Optimizer DAO Token", "ODP") {
    // On DAO creation, a vote/proposal is created which automatically creates a new one every x amount of time
    Proposal storage proposal = proposals.push();
    proposal.date = block.timestamp;
  }



  function joinDAO() public payable {
    // What is the minimum buy in for the DAO?
    require(msg.value >= 1 ether, "Minimum buy in is 1 ether");

    if (treasuryEth == 0) {

      // If there is nothing in the treasury, provide liquidity to treasury
      // LP tokens are initially provided on a 1:1 basis
      treasuryEth = msg.value;
      console.log(treasuryEth);
      // change to _mint
      _mint(msg.sender, treasuryEth);

    } else {
      // DAO members token count is diluted as more members join / add Eth
      treasuryEth += msg.value;
      uint ethReserve =  treasuryEth - msg.value;
      uint proportionOfTokens = (msg.value * totalSupply()) / ethReserve;
      // change to _mint
      _mint(msg.sender, proportionOfTokens);
    }
  }


  function leaveDAO() public {
    uint tokenBalance = balanceOf(msg.sender);
    require(tokenBalance > 0);

    // User gets back the relative % of the
    uint ethToWithdraw = (tokenBalance / totalSupply()) * treasuryEth;
    _burn(msg.sender, tokenBalance);
    payable(msg.sender).transfer(ethToWithdraw);
    treasuryEth -= ethToWithdraw;
  }


  function submbitVote(string[] memory _token, uint[] memory _perfOfToken, uint[] memory _confidenceLevels) public onlyMember {
    // User inputs token they'd like to vote on, the expected performance of token over time period and their confidence level
    // Loop through each token in list and provide a +1 on list
    // If token is in proposal, include in Struct and output average for Performance & confidence levels
    require((_token.length == _perfOfToken.length) && (_perfOfToken.length == _confidenceLevels.length), "Arrays must be the same size");

    uint numberOfVoterTokens = balanceOf(msg.sender);
    for (uint i = 0; i < _token.length; i++) {
      // get each value out of array
      proposals[proposals.length - 1].tokens.push(_token[i]);
      proposals[proposals.length - 1].userWeightings[_token[i]].push(_perfOfToken[i]);

      proposals[proposals.length - 1].numOfUserTokens[_token[i]].push(numberOfVoterTokens);
      proposals[proposals.length - 1].userConfidenceLevel[_token[i]].push(_confidenceLevels[i]);

    }
  }

  // Event to emit for Python script to pick up data for model?



  function findTokenWeight() public  {
    uint sumOfLPForToken;

    uint numeratorToken;
    uint numeratorConfidence;

    for (uint i = 0; i < proposals[proposals.length - 1].tokens.length; i++) {
      string memory _token = proposals[proposals.length - 1].tokens[i];
      sumOfLPForToken += proposals[proposals.length - 1].numOfUserTokens[_token][i];
      numeratorToken += proposals[proposals.length - 1].numOfUserTokens[_token][i] * proposals[proposals.length - 1].userWeightings[_token][i];
      numeratorConfidence += proposals[proposals.length - 1].numOfUserTokens[_token][i] * proposals[proposals.length - 1].userConfidenceLevel[_token][i];

      uint weightedAveragePerformance = numeratorToken / sumOfLPForToken;
      uint weightedAverageConfidence = numeratorConfidence / sumOfLPForToken;

      // This will return a number with 18 decimals, need to divide by 18
      proposals[proposals.length - 1].proposalFinalPerformance[_token] = weightedAveragePerformance;
      proposals[proposals.length - 1].proposalFinalConfidence[_token] = weightedAverageConfidence;
    }


    // Update Token weightings mapping
    // initialize tradesOnUniswap function

  }


  function initiateTradesOnUniswap() public {
    // 1. On initial trade, deposit contract ETH into WETH
    // 2. Take token weightings & swap WETH for for each token
    // 3.
  }

  modifier onlyMember {
      require(balanceOf(msg.sender) > 0);
      _;
   }

}
