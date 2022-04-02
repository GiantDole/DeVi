// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Job {

    struct GPS {
        uint16 longitude;
        uint16 latitude;
    }

    GPS gps;
    uint8 public bountyPerMinute;
    address private owner;
    //address[] private senders;
    address private contractor;
    uint256 timestamp;
    uint256 public timelimit;
    uint256 private timeSpent;
    uint256 public radius;

    uint256 public temp;


    constructor(
        uint16 _longitude, 
        uint16 _latitude, 
        uint8 _bounty, 
        address _owner, 
        uint8 _timelimit) {
        gps = GPS(_longitude, _latitude);
        bountyPerMinute = _bounty;
        owner = _owner;
        timestamp = 0;
        timelimit = _timelimit;
        timeSpent = 0;
    }

    //https://solidity-by-example.org/sending-ether/
    receive() external payable{
        temp = msg.value;
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

    }

    // function terminateJob() public {
    //     require(timeSpent == 0 && (msg.sender == owner || msg.sender == sender));
    //     timeSpent = block.timestamp - timelimit;

    //     //send reward to the sender
    //     uint amount = (timeSpent / 60) * bountyPerMinute;
    //     payable(sender).send(amount);

    //     //send remaining money back to requester
    //     payable(owner).send(address(this).balance);
    // }

    function sendmoney(address payable _to) public payable {
        bool sent = _to.send(10); 
        require(sent, "Failed to send eth");
    }

    // function collectReward() public {
    //     require(msg.sender == sender && timeSpent != 0);
    //     uint amount = (timeSpent / 60) * bountyPerMinute;
    //     payable(msg.sender).send(amount);
    // }
       
}