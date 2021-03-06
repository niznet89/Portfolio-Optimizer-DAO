// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@tableland/evm/contracts/ITablelandTables.sol";

contract EventNFT is Initializable, OwnableUpgradeable, ERC721URIStorageUpgradeable {
  using CountersUpgradeable for CountersUpgradeable.Counter;

  CountersUpgradeable.Counter private _tokenIds;
  address public constant usdcAddress = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
  string private constant _baseURIString = "https://testnet.tableland.network/query?s=";
  uint public price;
  uint public totalSupply;
  address public creator;

  /*
  ITablelandTables private _tableland;
  string private _metadataTable;
  uint256 private _metadataTableId;
  */

  function initialize(uint _totalSupply, uint _price, uint eventId, address _registery) external initializer {
     __ERC721_init("EventNFT", "TICKET");
     __Ownable_init();

     price = _price;
     totalSupply = _totalSupply;
    //  _tableland = ITablelandTables(_registery);

    /*
    * Stores the unique ID for the newly created table.
    */
    /*
     _metadataTableId = _tableland.createTable(
      address(this),
      string.concat(
        "CREATE TABLE event_",
        Strings.toString(block.chainid),
        " (id int, name text, description text, image text, total_supply int, price uint, date int);"
      )
    );


    /*
    * Stores the full tablename for the new table.
    * {prefix}_{chainid}_{tableid}

    _metadataTable = string.concat(
      "ticket_",
      StringsUpgradeable.toString(block.chainid),
      "_",
      StringsUpgradeable.toString(_metadataTableId)
    );
    */
  }

  function _baseURI() internal pure override returns (string memory) {
    return _baseURIString;
  }

  function buyTicket() external payable {
    /*
    IERC20 token = IERC20(usdcAddress);

    require(token.balanceOf(msg.sender) >= price, "Not enough USDC");
    token.transferFrom(msg.sender, address(this), price);
    */

    _safeMint(msg.sender, _tokenIds.current());

    emit TicketBought(msg.sender, _tokenIds.current());

    _tokenIds.increment();
  }

  function isCreator() public view returns(bool) {
    if (msg.sender == creator) {
      return true;
    } else {
      return false;
    }
  }

  // list of owners of tickets
  // owner of the event

  event TicketBought(address, uint);
}
