// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

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
    uint8 public timelimit;

    constructor(
        uint16 _longitude, 
        uint16 _lattitude, 
        uint8 _bounty, 
        address _owner, 
        uint8 _timelimit) {
        gps = GPS(_longitude, _lattitude);
        bountyPerMinute = _bounty;
        owner = _owner;
        locked = false;
        timestamp = 0;
        timelimit = _timelimit;
    }

    function acceptJob() public{
        //Sender accepting Job
        require(sender == address(0));
        sender = msg.sender;
    }

    function acceptRequest() public {
        //Requester accepting request
        require(msg.sender == owner);
        timestamp = now;
    }

    function denyRequest() public {
        //time elapsed or denied
        require(msg.sender == owner);
        delete sender;
        delete timestamp;
    }
       
}