// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./Job.sol";

contract JobFactory {

    address[] public allJobs;
    uint256 public value;

    event JobCreated(address job);

    function createJob(uint16 _longitude, uint16 _latitude, uint256 _bounty) public payable {
        address newJobAddr =  address(new Job(_longitude, _latitude, _bounty, msg.sender, 10));
        allJobs.push(newJobAddr);
        (bool sent, ) = payable(newJobAddr).call{value: msg.value}("");
        value = msg.value;
        require(sent, "Eth not sent to new job");
        emit JobCreated(newJobAddr);
    }

}
