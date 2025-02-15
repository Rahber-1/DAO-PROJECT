// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOToken is ERC20, Ownable {
    constructor() ERC20("CarbonDAO Token", "CDT") Ownable(msg.sender) {
        _mint(msg.sender, 1_000_000 * 10**decimals()); // Initial supply
    }

    // 🔹 Allow only the owner (DAOAdmin) to mint new tokens
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // 🔹 Allow burning tokens
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
