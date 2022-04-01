// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract Job {

    struct GPS {
        uint16 longitude;
        uint16 lattitude;
    }

    GPS gps;
    uint8 public bountyPerMinute;
    address private owner;
    //address[] private senders;
    address private sender;
    uint256 timestamp;
    uint256 public timelimit;
    uint256 private timeSpent;


    constructor(
        uint16 _longitude, 
        uint16 _lattitude, 
        uint8 _bounty, 
        address _owner, 
        uint8 _timelimit) {
        gps = GPS(_longitude, _lattitude);
        bountyPerMinute = _bounty;
        owner = _owner;
        timestamp = 0;
        timelimit = _timelimit;
        timeSpent = 0;
    }

    function acceptJob() public{
        //Sender accepting Job
        require(sender == address(0));
        sender = payable(msg.sender);
    }

    function acceptRequest() public {
        //Requester accepting request
        require(msg.sender == owner);
        timestamp = block.timestamp;
    }

    function denyRequest() public {
        //time elapsed or denied
        require(msg.sender == owner && timestamp == 0);
        delete sender;
    }

    function terminateJob() public {
        require(timeSpent == 0 && (msg.sender == owner || msg.sender == sender));
        timeSpent = block.timestamp - timelimit;

        //send reward to the sender
        uint amount = (timeSpent / 60) * bountyPerMinute;
        payable(sender).send(amount);

        //send remaining money back to requester
        payable(owner).send(address(this).balance);
    }

    function collectReward() public {
        require(msg.sender == sender && timeSpent != 0);
        uint amount = (timeSpent / 60) * bountyPerMinute;
        payable(msg.sender).send(amount);
    }
       
}