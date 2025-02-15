// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {DAOToken} from "../src/DAOToken.sol";
import {DAOAdmin} from  "../src/DAOAdmin.sol";
import {CarbonCredit} from  "../src/CarbonCredits.sol";

contract DAOTest is Test {
    DAOToken daoToken;
    CarbonCredit carbonCredit;
    DAOAdmin daoAdmin;
    address deployer;
    address user1 =makeAddr("user1");
    address user2 =makeAddr("user2");

    function setUp() public {
        deployer = address(this);
       

        daoToken = new DAOToken();
        carbonCredit = new CarbonCredit(deployer);
        daoAdmin = new DAOAdmin(address(daoToken), address(carbonCredit));
        carbonCredit.transferDAOAdmin(address(daoAdmin));
        // uint256 user1Balance=daoToken.mint(user1,(daoToken.totalSupply()*1/100));
      
    }

    function testMintTokens() public {
        uint256 initialBalance = daoToken.balanceOf(deployer);
        daoToken.mint(user1, 1000);
        assertEq(daoToken.balanceOf(user1), 1000);
        assertEq(daoToken.totalSupply(), initialBalance + 1000);
    }

    function testBurnTokens() public {
        daoToken.mint(user1, 1000);
        vm.prank(user1);
        daoToken.burn(500);
        assertEq(daoToken.balanceOf(user1), 500);
    }

    function testCreateProposal() public {
        daoToken.mint(user1, 1000);
        vm.prank(user1);
        daoAdmin.createProposal("Proposal 1", address(this), "0x");
        (uint256 id, address proposer, , , , , , , ,) = daoAdmin.proposals(0);
        console.log("the proposal id is: ",id);
        assertEq(id, 1);
        assertEq(proposer, user1);
    }

    function testVoteOnProposal() public {
        daoToken.mint(user1, 1000);
        daoAdmin.createProposal("Proposal 1", address(this), "0x");
        vm.prank(user1);
        daoAdmin.vote(0, true);
        (, , , uint256 votesFor, , , , , ,) = daoAdmin.proposals(0);
        assertEq(votesFor, 1000);
    }

    function testExecuteProposal() public {
        daoToken.mint(user1,(daoToken.totalSupply()*1)/100);
        console.log("user 1 balance:",daoToken.balanceOf(user1));
        daoAdmin.createProposal("Proposal 1", address(this), "0x");
        vm.prank(user1);
        daoAdmin.vote(0, true);
        vm.warp(block.timestamp + 8 days);
        daoAdmin.executeProposal(0);
        (, , , , , , ,bool executed, ,) = daoAdmin.proposals(0);
        assertTrue(executed);
    }
}