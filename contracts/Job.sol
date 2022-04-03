// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./libraries/Math.sol";

contract Job {

    struct GPS {
        int256 longitude;
        int256 latitude;
    }

    GPS gps;
    uint256 public radius;
    uint256 public bountyPerMinute;
    address private owner;
    address public contractor;
    uint256 startTime;
    uint256 public timeLimit; // in minutes
    uint256 private timeSpent; // in minutes
    uint256 public totalBounty;
    address public feeTo;
    uint256 public feeRate;
    uint256 public maxFee;
    bool started;

    event ContractorAcceptedJob(uint256 distanceFromPin);

    event OwnerAcceptedContractor();

    event OwnerRejectedContractor();

    event OwnerCanceledJob();

    event JobFinished(uint256 paidToContractor, uint256 earned, uint256 refundedToOwner);

    constructor(
        int256 _longitude, 
        int256 _latitude, 
        uint256 _radius, 
        uint256 _bountyPerMinute, 
        address _owner,
        address _feeTo,
        uint256 _feeRate
        ) {
        gps = GPS(_longitude, _latitude);
        radius = _radius;
        bountyPerMinute = _bountyPerMinute;
        owner = _owner;
        feeTo = _feeTo;
        feeRate = _feeRate;
        startTime = 0;
        timeSpent = 0;
        started = false;
    }

    //https://solidity-by-example.org/sending-ether/
    // check if value is greater than bounty per minute
    receive() external payable {
        require(msg.value > bountyPerMinute, "Bounty per minute greater than value deposited.");
        maxFee = (msg.value * feeRate) / 100;
        totalBounty = msg.value - maxFee;
        timeLimit = totalBounty / bountyPerMinute;
    }

    // worker submits a proposal to owner
    // need to check that the worker's blockchain address is valid
    // need to check that the worker's geolocation is within a certain radius
    function contractorAcceptJob(int256 _long, int256 _lat) public {
        //Sender accepting Job
        require(started == false, "Job has started");
        require(contractor == address(0), "Contract has already been accepted by another contractor");
        require(msg.sender != owner, "Contractor cannot be owner");
        require(_lat >= -9000000 && _lat <= 9000000, "Latitude not in bounded range");
        require(_long >= -18000000 && _long <= 18000000, "Longitude not in bounded range");
        uint256 d = Math.sqrt(uint(((_long - gps.longitude) ** 2) + ((_lat - gps.latitude) ** 2)));
        // 111138 meters per lat/long
        uint256 d_meters = d * 111139 / 100000;
        require(d_meters <= radius, "Geolocation outside of desired location");
        contractor = payable(msg.sender);
        emit ContractorAcceptedJob(d_meters);
    }

    // owner accepts sender's proposal
    // start timer
    // should schedule a function call to finishJob when timelimit is reached
    function ownerAcceptContractor() public {
        //Requester accepting request
        require(started == false, "Job has started");
        require(msg.sender == owner && contractor != address(0));
        startTime = block.timestamp;
        started = true;
        emit OwnerAcceptedContractor();
    }

    function ownerRejectConctractor() public {
        //time elapsed or denied
        require(started == false, "Job has started");
        require(msg.sender == owner && startTime == 0);
        delete contractor;
        emit OwnerRejectedContractor();
    }

    function finishJob() public {
        require(started == true, "Job not started");
        require(msg.sender == owner || msg.sender == contractor, "Only owner or contractor can finish job");
        timeSpent = (block.timestamp - startTime) / 60;
        if (timeSpent > timeLimit) {
            timeSpent = timeLimit;
        }

        //send reward to the sender
        uint256 amount = timeSpent * bountyPerMinute;
        (bool paidContractor, ) = payable(contractor).call{value: amount}("");
        require(paidContractor, "Payment did not reach contractor");

        //send money to company
        uint256 actualFee = (timeSpent / timeLimit) * maxFee;
        (bool collectedFee, ) = payable(feeTo).call{value: actualFee}("");
        require(collectedFee, "Fee did not reach company address");

        emit JobFinished(amount, actualFee, address(this).balance);

        //send remaining money back to requester
        selfdestruct(payable(owner));
    }

    function cancelJob() public {
        require(started == false, "Job has started");
        require(msg.sender == owner, "You must be the job owner to cancel this job");
        delete contractor;
        delete owner;
        emit OwnerCanceledJob();
        selfdestruct(payable(owner));
    }
}