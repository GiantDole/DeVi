// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./Job.sol";

contract JobFactory {

    address[] public allJobs;

    event JobCreated(address job);

    function createJob(uint16 _longitude, uint16 _latitude, uint8 _bounty) public payable {
        address newJobAddr =  address(new Job(_longitude, _latitude, _bounty, msg.sender, 10));
        allJobs.push(newJobAddr);
        (bool sent, bytes memory data) = payable(newJobAddr).call{value: msg.value}("");
        require(sent, "Eth not sent to new job");
        emit JobCreated(newJobAddr);
    }
}
