// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./job.sol";

contract JobCreator {

    function createJob(uint16 _longitude, uint16 _lattitude, uint8 _bounty) public returns(Job) {
        Job job = new Job(_longitude, _lattitude, _bounty, msg.sender);
        return job;
    }
}

