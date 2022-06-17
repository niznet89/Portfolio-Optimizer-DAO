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

  //
  mapping(string => uint) public assetWeightings;

  // Proposal struct of token, expected performance and confidence level.
  struct Proposal {
    uint date;
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


  constructor(address _LPTokenAddress) {
    LPTokenAddress = _LPTokenAddress;
    // On DAO creation, a vote/proposal is created which automatically creates a new one every x amount of time
    Proposal storage proposal = proposals.push();
    proposal.date = block.timestamp;
  }



  function joinDAO() public payable {
    // What is the minimum buy in for the DAO?
    require(msg.value > 1 ether);

    if (treasuryEth == 0) {

      // If there is nothing in the treasury, provide liquidity to treasury
      // LP tokens are initially provided on a 1:1 basis
      treasuryEth = msg.value;
      ERC20(LPTokenAddress).transferFrom(address(this), msg.sender, treasuryEth);
      tokenReserve = ERC20(LPTokenAddress).totalSupply() - ERC20(LPTokenAddress).balanceOf(address(this));

    } else {
      // DAO members token count is diluted as more members join / add Eth
      uint proportionOfTokens = (msg.value * tokenReserve) / treasuryEth;
      tokenReserve += proportionOfTokens;
      treasuryEth += msg.value;
      ERC20(LPTokenAddress).transferFrom(address(this), msg.sender, proportionOfTokens);
    }
  }


  function leaveDAO() public {
    uint tokenBalance = ERC20(LPTokenAddress).balanceOf(msg.sender);
    require(tokenBalance > 0);

    // User gets back the relative % of the
    uint ethToWithdraw = (tokenBalance / tokenReserve) * treasuryEth;
    ERC20(LPTokenAddress).transferFrom(msg.sender, address(this), tokenBalance);
    payable(msg.sender).transfer(ethToWithdraw);
    tokenReserve -= tokenBalance;
    treasuryEth -= ethToWithdraw;
  }


  function submbitVote(string[] memory _token, int[] memory _perfOfToken, uint[] memory _confidenceLevels) public onlyMember {
    // User inputs token they'd like to vote on, the expected performance of token over time period and their confidence level
    // Loop through each token in list and provide a +1 on list
    // If token is in proposal, include in Struct and output average for Performance & confidence levels
    require((_token.length == _perfOfToken.length) && (_perfOfToken.length == _confidenceLevels.length), "Arrays must be the same size");

    uint numberOfVoterTokens = ERC20(LPTokenAddress).balanceOf(msg.sender);
    for (uint i = 0; i < _token.length; i++) {
      // get each value out of array
      proposals[proposals.length - 1].userWeightings[_token[i]].push(_perfOfToken[i]);
      proposals[proposals.length - 1].numOfUserTokens[_token[i]].push(numberOfVoterTokens[i]);
      proposals[proposals.length - 1].userConfidenceLevel[_token[i]].push(_confidenceLevels[i]);

    }
  }


  function findTokenWeight(string memory _token) public returns(uint) {
    uint sumOfLPForToken;

    uint numeratorToken;
    uint numeratorConfidence;

    for (uint i = 0; i < proposals[proposals.length - 1].tokenWeightings[_token].length; i++) {
      sumOfLPForToken += proposals[proposals.length - 1].tokenWeightings[_token][i];
      numeratorToken += proposals[proposals.length - 1].numOfUserTokens[_token][i] * proposals[proposals.length - 1].userWeightings[_token][i];
      numeratorConfidence += proposals[proposals.length - 1].numOfUserTokens[_token][i] * proposals[proposals.length - 1].userConfidenceLevel[_token][i];
    }
    uint weightedAveragePerformance = numeratorToken / sumOfLPForToken;
    uint weightedAverageConfidence = numeratorConfidence / sumOfLPForToken;
    proposals[proposals.length - 1].proposalFinalPerformance[_token] = weightedAveragePerformance;
    proposals[proposals.length - 1].proposalFinalConfidence[_token] = weightedAverageConfidence;

    // Update Token weightings mapping
    // initialize tradesOnUniswap function

  }

  function rebalance() public {
    // Function is hit by external source... Chainlink?
    // Asset weightings is adjusted based on model
  }

  function initiateTradesOnUniswap() public {

  }

  modifier onlyMember {
      require(ERC20(LPTokenAddress).balanceOf(msg.sender) > 0);
      _;
   }

}
