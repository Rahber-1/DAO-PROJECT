// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;




/**
* title: CarbonCredits
* author: Rahbar Ahmed
* notice: this contract is meant to be governed by the DAO
* here the DAO contract DAOAdmin contract
* which requires community members to hold DAOToken(ERC20) in order to vote or make 
* a proposal.
*/

contract CarbonCredit {
    // DAO Admin address
    address public DAOAdmin;
    
    // Token balance mapping
    mapping(address => uint256) private balances;

    // Total supply of carbon credits
    uint256 public totalSupply;

    // Events
    event CreditIssued(address indexed company, uint256 amount);
    event CreditsBurned(address indexed company, uint256 amount);

    // Modifier to restrict functions to DAOAdmin
    modifier onlyDAO() {
        require(msg.sender == DAOAdmin, "Not authorized");
        _;
    }

    constructor(address _DAOAdmin) {
        DAOAdmin = _DAOAdmin;
    }

    // Function to issue new carbon credits to a company
    function issueCredits(address company, uint256 amount) external onlyDAO {
        balances[company] += amount;
        totalSupply += amount;
        emit CreditIssued(company, amount);
    }

    /*
    *  notice:Function to burn carbon credits after DAO Admin approval
    *  This function is meant to be used for restricting double spend of carbon credits
    *  Thus this function needs an external verification which should be done by some Third-party auditor
    *  and it's report must be fed back into this smart contract via oracles,through burnCredits function
    *  credits are removed from circulation permanently OR this can also be done by time-bound method
    *  in which after one year of issuance, carbon credits for that company automatically gets burned.
    */
    function burnCredits(address company, uint256 amount) external onlyDAO {
        require(balances[company] >= amount, "Insufficient credits");
        
        balances[company] -= amount;
        totalSupply -= amount;
        emit CreditsBurned(company, amount);
    }

   

    // DAOAdmin can transfer the admin role to another address
    function transferDAOAdmin(address newDAOAdmin) external onlyDAO {
        DAOAdmin = newDAOAdmin;
    }

     // Function to view the balance of a company
    function getbalanceOf(address company) external view returns (uint256) {
        return balances[company];
    }
}
