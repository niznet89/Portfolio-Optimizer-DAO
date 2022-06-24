//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ShortBtc is ERC20 {

    constructor() ERC20("BTC short token", "sBTC") {
    }

    // mint can be called by authorised caller to mint MyToken in existence.
    function mint(address beneficiary, uint256 _amount) external {
            // Effects: print the new MyTokens into existence.
           _mint(beneficiary, _amount);

        }

    // mint can be called by authorised caller to mint MyToken in existence.
    function burn(address beneficiary, uint256 _amount) external {
            // Effects: print the new MyTokens into existence.
           _burn(beneficiary, _amount);

        }
}
