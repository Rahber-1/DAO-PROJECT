// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;





interface ICarbonCredit {
    function issueCredits(address recipient, uint256 amount) external;
}