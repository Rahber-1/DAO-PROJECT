

# DAO for Carbon Credit Token System

## Overview

This project implements a decentralized autonomous organization (DAO) for managing a Carbon Credit Token (CDT) system on the Ethereum blockchain. The DAO structure includes four smart contracts:

- **DAOToken**: The ERC20 token representing ownership and participation in the DAO.
- **DAOAdmin**: The governance contract responsible for managing proposals, voting, and executing decisions.
- **ICarbonCredit**: An interface for interacting with carbon credit issuance contracts.
- **CarbonCredit**: A contract for issuing and burning carbon credits, governed by the DAOAdmin contract.

This DAO allows token holders to participate in decision-making processes, vote on proposals, and govern the issuance and management of carbon credits.
## 🚀 Installation & Setup  

### 1️⃣ **Clone the Repository**  
git clone https://github.com/Rahber-1/DAO-PROJECT.git
cd DAO-PROJECT

### 2️⃣ **Install Foundry**  
curl -L https://foundry.paradigm.xyz | bash  
foundryup  

### 3️⃣ **Install Dependencies**  
forge install  

### 4️⃣ **Compile the Contracts**  
forge build  

### 5️⃣ **Run Tests**  
forge test -vv  

## Contract Descriptions

### 1. **DAOToken (CDT)**
This contract implements the ERC20 standard for the CarbonDAO token (CDT), which is the governance token of the DAO. Key features include:

- **Minting**: Only the owner (DAOAdmin) can mint new tokens.
- **Burning**: Users can burn their tokens to reduce the circulating supply.

**Constructor:**
- The contract starts with a fixed supply of 1,000,000 CDT tokens minted to the owner’s address.

**Functions:**
- `mint(address to, uint256 amount)`: Allows the owner to mint new CDT tokens.
- `burn(uint256 amount)`: Allows users to burn CDT tokens.

### 2. **DAOAdmin**
This is the governance contract that allows token holders to create proposals, vote, and execute decisions on behalf of the DAO.

**Key Features:**
- **Proposal Creation**: Token holders can create proposals that execute on-chain actions (e.g., interacting with other contracts).
- **Voting**: Users can vote on proposals directly or delegate their votes to others.
- **Execution**: Proposals can be executed if the quorum and voting period are met.

**Constructor:**
- The contract is initialized with the DAO token address and the carbon credit contract address.

**Functions:**
- `delegateVote(address delegatee)`: Allows a user to delegate their voting power to another address.
- `createProposal(string calldata description, address target, bytes calldata data)`: Creates a proposal with a description, target contract address, and data to execute.
- `takeSnapshot(uint256 proposalId)`: Takes a snapshot of the current state at the time of proposal creation (optional).
- `vote(uint256 proposalId, bool support)`: Allows users to vote on proposals, either directly or through delegation.
- `executeProposal(uint256 proposalId)`: Executes a proposal if the quorum is met and the proposal passes.

### 3. **ICarbonCredit**
This contract interface allows interaction with the Carbon Credit issuance system.

**Functions:**
- `issueCredits(address recipient, uint256 amount)`: Issues carbon credits to a recipient address.

### 4. **CarbonCredit**
The **CarbonCredit** contract manages the issuance and burning of carbon credits. It is governed by the DAO through the DAOAdmin contract.

**Key Features:**
- **Issue Credits**: Allows the DAOAdmin to issue carbon credits to a company or organization.
- **Burn Credits**: Allows the DAOAdmin to burn credits, which can be used to remove credits from circulation, either manually or via external audits.
- **Transfer Admin Role**: The DAOAdmin role can be transferred to another address, enabling flexibility in governance.

**Constructor:**
- The contract is initialized with the DAOAdmin address.

**Functions:**
- `issueCredits(address company, uint256 amount)`: Issues carbon credits to a specified company.
- `burnCredits(address company, uint256 amount)`: Burns carbon credits for a company, effectively removing them from circulation.
- `transferDAOAdmin(address newDAOAdmin)`: Transfers the DAOAdmin role to a new address.
- `getbalanceOf(address company)`: Returns the carbon credit balance of a specified company.

## How to Use

### 1. **Deploying the DAO**
To deploy the DAO system, you need to deploy the following:

1. **DAOToken** contract.
2. **Carbon Credit** contract that implements the `ICarbonCredit` interface.
3. **DAOAdmin** contract, passing the deployed addresses of `DAOToken` and `Carbon Credit` contracts.

### 2. **Voting and Proposal Creation**
- Token holders can create proposals by calling `createProposal` on the `DAOAdmin` contract.
- They can delegate votes by calling `delegateVote` to assign voting power to another address.
- Votes are cast using the `vote` function, where token balances determine the weight of each vote.

### 3. **Executing Proposals**
- Proposals can be executed once the voting period has ended, and the quorum requirement is met. The owner of the DAO (DAOAdmin) or any authorized address can execute the proposal.

### 4. **Managing Carbon Credits**
- The DAOAdmin can issue new carbon credits to companies via the `CarbonCredit` contract using the `issueCredits` function.
- The DAOAdmin can also burn carbon credits through the `burnCredits` function, effectively removing credits from circulation.

## Key Events

- `ProposalCreated`: Emitted when a proposal is created.
- `Voted`: Emitted when a vote is cast for a proposal.
- `ProposalExecuted`: Emitted when a proposal is executed.
- `VoteDelegated`: Emitted when voting power is delegated to another address.
- `SnapshotTaken`: Emitted when a snapshot is taken for a proposal.
- `CreditIssued`: Emitted when carbon credits are issued to a company.
- `CreditsBurned`: Emitted when carbon credits are burned.

## Requirements

- Solidity version: ^0.8.19 (or higher) for the DAO contracts.
- OpenZeppelin contracts: ERC20, Ownable.
- Ethereum-compatible blockchain (e.g., Ethereum, Polygon).

## Future Enhancements

- Integrate additional features like time-based voting or multi-signature proposal execution.
- Implement a more advanced carbon credit system with verifiable third-party carbon credit registries.

## License

This project is licensed under the MIT License.

---

