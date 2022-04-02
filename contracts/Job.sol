// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Job {

    struct GPS {
        uint16 longitude;
        uint16 latitude;
    }

    GPS gps;
    uint256 public bountyPerMinute;
    address private owner;
    //address[] private senders;
    //make private again after testing:
    address public contractor;
    uint256 timestamp;
    uint256 public timeLimit;
    uint256 private timeSpent;
    uint256 public radius;
    uint256 public totalBounty;
    address public feeTo;
    uint256 public feeRate;
    uint256 public maxFee;


    constructor(
        uint16 _longitude, 
        uint16 _latitude, 
        uint256 _bountyPerMinute, 
        address _owner,
        address _feeTo,
        uint256 _feeRate
        ) {
        gps = GPS(_longitude, _latitude);
        bountyPerMinute = _bountyPerMinute;
        owner = _owner;
        feeTo = _feeTo;
        feeRate = _feeRate;
        timestamp = 0;
        timeSpent = 0;
    }

    //https://solidity-by-example.org/sending-ether/
    // check if value is greater than bounty per minute
    receive() external payable {
        require(msg.value > bountyPerMinute, "Bounty per minute greater than value deposited.");
        maxFee = msg.value * feeRate / 100;
        totalBounty = msg.value - maxFee;
        timeLimit = (totalBounty / bountyPerMinute) * 60;
    }

    // worker submits a proposal to owner
    // need to check that the worker's blockchain address is valid
    // need to check that the worker's geolocation is within a certain radius
    function contractorAcceptJob() public{
        //Sender accepting Job
        require(contractor == address(0));
        contractor = payable(msg.sender);
    }

    // owner accepts sender's proposal
    // start timer
    function ownerAcceptContractor() public {
        //Requester accepting request
        require(msg.sender == owner && contractor != address(0));
        timestamp = block.timestamp;
    }

    function ownerRejectConctractor() public {
        //time elapsed or denied
        require(msg.sender == owner && timestamp == 0);
        delete contractor;
    }

    function finishJob() public {
        require(timeSpent == 0 && (msg.sender == owner || msg.sender == contractor));
        timeSpent = block.timestamp - timeLimit;

        //send reward to the sender
        uint256 amount = (timeSpent / 60) * bountyPerMinute;
        (bool paidContractor, ) = payable(contractor).call{value: amount}("");
        require(paidContractor, "Payment did not reach contractor");

        //send money to company
        uint actualFee = (timeSpent / timeLimit) * maxFee;
        (bool collectedFee, ) = payable(feeTo).call{value: actualFee}("");
        require(collectedFee, "Fee did not reach company address");

        //send remaining money back to requester
        //(bool refundedOwner, ) = payable(owner).call{value: totalBounty - amount}("");
        //(bool refundedOwner, ) = payable(owner).call{value: address(this).balance}("");
        selfdestruct(payable(owner));
        //require(refundedOwner, "Refund did not reach owner");
    }

    function cancelJob() public {
        require(msg.sender == owner, "You must be the job owner to cancel this job");
        selfdestruct(payable(owner));
        delete contractor;
        delete owner;
    }
}