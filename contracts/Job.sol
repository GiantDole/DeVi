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
    address private contractor;
    uint256 timestamp;
    uint256 public timeLimit;
    uint256 private timeSpent;
    uint256 public radius;

    uint256 public totalBounty;


    constructor(
        uint16 _longitude, 
        uint16 _latitude, 
        uint256 _bountyPerMinute, 
        address _owner
        //uint8 _timelimit
        ) {
        gps = GPS(_longitude, _latitude);
        bountyPerMinute = _bountyPerMinute;
        owner = _owner;
        timestamp = 0;
        //timelimit = _timelimit;
        timeSpent = 0;
    }

    //https://solidity-by-example.org/sending-ether/
    // check if value is greater than bounty per minute
    receive() external payable {
        require(msg.value > bountyPerMinute, "Bounty per minute greater than value deposited.");
        totalBounty = msg.value;
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

    function terminateJob() public {
        require(timeSpent == 0 && (msg.sender == owner || msg.sender == contractor));
        timeSpent = block.timestamp - timelimit;

        //send reward to the sender
        uint256 amount = (timeSpent / 60) * bountyPerMinute;
        (bool paidContractor, ) = payable(contractor).call{value: amount}("");
        require(paidContractor);

        //send remaining money back to requester
        (bool refundedOwner, ) = payable(owner).call{value: totalBounty - amount}("");
        require(refundedOwner);
    }

    // function collectReward() public {
    //     require(msg.sender == sender && timeSpent != 0);
    //     uint amount = (timeSpent / 60) * bountyPerMinute;
    //     payable(msg.sender).send(amount);
    // }
       
}