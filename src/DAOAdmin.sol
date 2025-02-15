// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from"@openzeppelin/contracts/access/Ownable.sol";
import {ICarbonCredit} from "./interfaces/ICarbonCredit.sol";



contract DAOAdmin is Ownable {
    ///////////////////
    ////EVENTS////////
    /////////////////
    event ProposalCreated(uint256 proposalId, address proposer, string description);
    event Voted(uint256 proposalId, address voter, bool support);
    event ProposalExecuted(uint256 proposalId, bool success);
    event VoteDelegated(address from, address to);
    event SnapshotTaken(uint256 proposalId, uint256 timestamp);

    ////////////////////////
    /////STATE VARIABLES///
    //////////////////////
    IERC20 public daoToken;
    ICarbonCredit public carbonCreditContract;

    uint256 public proposalCount;
    uint256 public quorumPercentage = 1;  //% oftotal votes required
    uint256 public votingPeriod = 7 days;
    uint256 public executionDelay = 1 days;

    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 createdAt;
        uint256 executionTime;
        bool executed;
        address target;
        bytes data;
        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => address) public voteDelegation;

   

    constructor(address _daoToken, address _carbonCreditContract) Ownable(msg.sender) {
        daoToken = IERC20(_daoToken);
        carbonCreditContract = ICarbonCredit(_carbonCreditContract);
    }
    //////////////////////////////////////////////////
    ///////////EXTERNAL & PUBLIC FUNCTIONS///////////
    ////////////////////////////////////////////////
    //Delegate voting power
    function delegateVote(address delegatee) external {
        require(delegatee != msg.sender, "Cannot delegate to yourself");
        require(daoToken.balanceOf(msg.sender) > 0, "Must hold DAO tokens");

        voteDelegation[msg.sender] = delegatee;
        emit VoteDelegated(msg.sender, delegatee);
    }

    //Create a proposal with on-chain execution
    function createProposal(string calldata description, address target, bytes calldata data) external {
        require(daoToken.balanceOf(msg.sender) > 0, "Must hold DAO tokens to propose");

        Proposal storage newProposal = proposals[proposalCount++];
        newProposal.id = proposalCount;
        newProposal.proposer = msg.sender;
        newProposal.description = description;
        newProposal.createdAt = block.timestamp;
        newProposal.executionTime = block.timestamp + votingPeriod + executionDelay;
        newProposal.target = target;
        newProposal.data = data;

        emit ProposalCreated(newProposal.id, msg.sender, description);
    }

    // 🔹 Snapshot off-chain at proposal creation (optional)
    function takeSnapshot(uint256 proposalId) external {
        emit SnapshotTaken(proposalId, block.timestamp);
    }

    // 🔹 Vote on a proposal (direct or delegated)
    function vote(uint256 proposalId, bool support) external {
        require(block.timestamp <= proposals[proposalId].createdAt + votingPeriod, "Voting period over");
        require(!proposals[proposalId].hasVoted[msg.sender], "Already voted");
        Proposal storage proposal = proposals[proposalId];
        
       

        address voter = msg.sender;
        if (voteDelegation[msg.sender] != address(0)) {
            voter = voteDelegation[msg.sender];
        }

        uint256 voterBalance = daoToken.balanceOf(voter);
        require(voterBalance > 0, "Must hold DAO tokens to vote");

        if (support) {
            proposal.votesFor += voterBalance;
        } else {
            proposal.votesAgainst += voterBalance;
        }

        proposal.hasVoted[msg.sender] = true;
        emit Voted(proposalId, msg.sender, support);
    }

    //Execute proposal if quorum is met
    function executeProposal(uint256 proposalId) external {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp >= proposal.executionTime, "Timelock not over");
        require(!proposal.executed, "Proposal already executed");

        uint256 totalSupply = daoToken.totalSupply();
        uint256 totalVotes = proposal.votesFor + proposal.votesAgainst;
        uint256 quorum = (totalSupply * quorumPercentage) / 100;

        require(totalVotes >= quorum, "Quorum not reached");

        if (proposal.votesFor > proposal.votesAgainst) {
            proposal.executed = true;
            (bool success, ) = proposal.target.call(proposal.data);
            require(success, "Proposal execution failed");

            emit ProposalExecuted(proposalId, success);
        } else {
            proposal.executed = true;
            emit ProposalExecuted(proposalId, false);
        }
    }
}
