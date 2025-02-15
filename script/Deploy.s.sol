// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script,console} from "forge-std/Script.sol";
import {DAOToken} from "../src/DAOToken.sol";
import {DAOAdmin} from  "../src/DAOAdmin.sol";
import {CarbonCredit} from  "../src/CarbonCredits.sol";

contract DeployDAO is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy DAOToken
        DAOToken daoToken = new DAOToken();
        console.log("DAOToken deployed at:", address(daoToken));

        // Deploy CarbonCredit contract
        CarbonCredit carbonCredit = new CarbonCredit(msg.sender);
        console.log("CarbonCredit deployed at:", address(carbonCredit));

        // Deploy DAOAdmin with DAOToken and CarbonCredit contract addresses
        DAOAdmin daoAdmin = new DAOAdmin(address(daoToken), address(carbonCredit));
        console.log("DAOAdmin deployed at:", address(daoAdmin));

        // Transfer CarbonCredit contract ownership to DAOAdmin
        carbonCredit.transferDAOAdmin(address(daoAdmin));

        vm.stopBroadcast();
    }
}
