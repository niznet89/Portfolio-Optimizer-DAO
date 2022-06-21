//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenSwap.sol";

contract OptimizerDAO is TokenSwap, ERC20 {
  // May be able to delete membersTokenCount as tally is taken care of in ERC contract
  uint public treasuryEth;
  uint public startingEth;
  uint public lastSnapshotEth;

  mapping(string => address) private tokenAddresses;
  // Address's included in mapping
  /**
  address private constant WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
  address private constant BAT = 0xDA5B056Cfb861282B4b59d29c9B395bcC238D29B;
  address private constant WBTC = 0x0014F450B8Ae7708593F4A46F8fa6E5D50620F96;
  address private constant UNI = 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984;
  address private constant MKR = 0xF9bA5210F91D0474bd1e1DcDAeC4C58E359AaD85;
  */

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
    string[5] memory _tokens = ['WETH', 'BAT', 'WBTC', 'UNI', 'MKR'];
    string[5] memory _addresses = [0xc778417E063141139Fce010982780140Aa0cD5Ab, 0xDA5B056Cfb861282B4b59d29c9B395bcC238D29B, 0x0014F450B8Ae7708593F4A46F8fa6E5D50620F96, 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984, 0xF9bA5210F91D0474bd1e1DcDAeC4C58E359AaD85];
    for (uint i = 0; i < _tokens.length; i++) {
      tokenAddresses[_tokens[i]] = _addresses[i];
    }
  }



  function joinDAO() public payable {
    // What is the minimum buy in for the DAO?
    require(msg.value >= 1 ether, "Minimum buy in is 1 ether");

    if (treasuryEth == 0) {

      // If there is nothing in the treasury, provide liquidity to treasury
      // LP tokens are initially provided on a 1:1 basis
      treasuryEth = msg.value;
      startingEth = treasuryEth;
      console.log(treasuryEth);
      // change to _mint
      _mint(msg.sender, treasuryEth);

    } else {
      // DAO members token count is diluted as more members join / add Eth
      treasuryEth += msg.value;
      startingEth = treasuryEth;
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


  function initiateTradesOnUniswap(uint[] memory _assets, uint[] memory _percentage) public {
    // 1. On initial trade, deposit contract ETH into WETH
    // 2. Take token weightings & swap WETH for for each token
    // 3.
    // 2. Sell off existing tokens for WETH
    if (proposals.length > 0) {
      (bool success, ) = WETH.call{value: address(this).balance}(abi.encodeWithSignature("deposit()"));
      require(success, "The transaction failed");
      for (uint i = 0; i < _assets.length; i++) {
        swap(tokenAddresses[_assets[i]], tokenAddresses["WETH"], ERC20(tokenAddresses[_assets[i]]).balanceOf(this(address)), 0, address(this));
      }
      lastSnapshotEth = ERC20(tokenAddresses["WETH"]).balanceOf(address(this));

      for (uint i = 0; i < _assets.length; i++) {
        uint memory allocation = _percentage[i] * ERC20(tokenAddresses["WETH"]).balanceOf(address(this));
        swap(WETH, tokenAddresses[_assets[i]], allocation, 0, address(this));
      }
      // 3. Loop through assets & trade for tokens based on new weightings
      // 4. Create new proposal
      Proposal newProposal = proposals.push();
      newProposal.date = block.timestamp;
    } else {
      (bool success, ) = WETH.call{value: address(this).balance}(abi.encodeWithSignature("deposit()"));
      require(success, "The transaction failed");

      for (uint i = 0; i < _assets.length; i++) {
        uint memory allocation = _percentage[i] * ERC20(tokenAddresses["WETH"]).balanceOf(address(this));
        swap(WETH, tokenAddresses[_assets[i]], allocation, 0, address(this));
      }
      // 3. Loop through assets & trade for tokens based on new weightings
      // 4. Create new proposal
      Proposal newProposal = proposals.push();
      newProposal.date = block.timestamp;

    }

  }

  modifier onlyMember {
      require(balanceOf(msg.sender) > 0);
      _;
   }

}
