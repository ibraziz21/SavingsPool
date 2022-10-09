// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract savingPool {
        address internal owner; 
        address internal recepient;

        // state variables used by owner function
        uint internal currentParticipants;
        uint public contributionAmt;
        uint public maxParticipants;
       uint public endTime;
        mapping (address => bool) internal hasBeenBeneficiary;

    struct depositPayment {
        uint balance;
        bool hasApproved;
    }
    mapping(address=>depositPayment) public verifiedUser;

    constructor() {
            owner=msg.sender;        
    }

modifier onlyOwner {
    require(msg.sender==owner,"Not Authorized to run this function");
    _;
}

/* @Owner Privileges
1. Sets the contribution amount
2. Sets the maximum no. of participants
3. Sets current beneficiary

*/
//set the contribution amount per user, and participants function
function setPoolDetails(uint _amt, uint _noOfParticipants) external  onlyOwner {
    require(_amt!=0 && _noOfParticipants!=0, "We can't have an empty pool");
    contributionAmt = _amt;
    maxParticipants = _noOfParticipants;
   
}
function currentBeneficiary(address Address)public onlyOwner {
    require(hasBeenBeneficiary[Address]==false,"Has already been a beneficiary");
    recepient = Address;   
}
function FinishTime(uint _time) public onlyOwner{
    require(block.timestamp<_time,"Ending time should be into the future");
    endTime = _time;
}

/*
@contributer functions
1. Joins a pool
2. Pays a deposit to the smart contract
3. Pays set amount
*/
function joinPool()public payable {
    require(verifiedUser[msg.sender].hasApproved==false, "Already in the pool");
    uint depositAmt = 2*contributionAmt; 
    require(currentParticipants<maxParticipants,"Pool is full");
    require(msg.value==depositAmt,"Incorrect Value Sent");
    verifiedUser[msg.sender].balance = depositAmt;
    verifiedUser[msg.sender].hasApproved = true;
    currentParticipants++;
}
//contribute function variables to be used
uint public PoolBalance;
struct poolDetails {
  uint paidTotal;
  bool hasPaid;
}
mapping (address => poolDetails)public poolContribution;
function contribute() external payable {
    require(verifiedUser[msg.sender].hasApproved, "Not an approved contributor");
    require(msg.value==contributionAmt,"Incorrect Value Sent");

    
    PoolBalance+=msg.value;
    poolContribution[msg.sender].paidTotal+=msg.value;
    poolContribution[msg.sender].hasPaid=true;
}

//withdraw function can only be accessed by the current recepient
function withdrawPool() external  {
    require(msg.sender==recepient,"It is not your turn to receive the pool");
    uint send = PoolBalance;
    PoolBalance=0;
    payable(msg.sender).transfer(send);

    
}

}