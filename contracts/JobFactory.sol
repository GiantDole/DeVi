// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./Job.sol";

contract JobFactory {

    address public feeTo;
    address public feeToSetter;
    uint256 public feeRate;
    address[] public allJobs;

    mapping(address => Job[]) contractorHistory;

    event JobCreated(address job);

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    // https://gisjames.wordpress.com/2016/04/27/deciding-how-many-decimal-places-to-include-when-reporting-latitude-and-longitude/
    function createJob(int256 _longitude, int256 _latitude, uint256 radius, uint256 _bountyPerMinute) public payable {
        require(_latitude > -9000000 && _latitude < 9000000, "Latitude not in bounded range");
        require(_longitude > -18000000 && _longitude < 18000000, "Longitude not in bounded range");
        address newJobAddr =  address(new Job(_longitude, _latitude, radius, _bountyPerMinute, msg.sender, feeTo, feeRate, this));
        allJobs.push(newJobAddr);
        (bool sent, ) = payable(newJobAddr).call{value: msg.value}("");
        require(sent, "Eth not sent to new job");
        emit JobCreated(newJobAddr);
    }

    function getAllPastJobs(address _contractor) external view returns(Job[] memory) {
        return contractorHistory[_contractor];
    }

    function getAverageContractorRating(address _contractor) external view returns(uint8) {
        Job[] memory jobs = contractorHistory[_contractor];
        uint totalRating = 0;
        uint totalJobs = 0;
        for (uint i=0; i<jobs.length; i++) {
            Job job = jobs[i];
            uint8 rating = job.contractorRating();
            if (rating > 0) {
                totalJobs++;
                totalRating+=rating;
            }
        }

        if(totalRating == 0) {
            return 0;
        }
        return uint8((totalRating * 100) / totalJobs);
    }

    function addNewContractorJob(Job _job) public {
        require(msg.sender == address(_job), "Only the job contract can add itself");
        contractorHistory[_job.contractor()].push(_job);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "Address is not setter.");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "Address is not setter.");
        feeToSetter = _feeToSetter;
    }

    function setFeeRate(uint256 _feeRate) external {
        require(msg.sender == feeToSetter, "Address is not setter.");
        require(_feeRate < 100, "Fee rate greater than 100%.");
        feeRate = _feeRate;
    }
}
