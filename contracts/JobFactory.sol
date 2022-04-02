// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./Job.sol";

contract JobFactory {

    address public feeTo;
    address public feeToSetter;

    address[] public allJobs;
    uint256 public value;


    event JobCreated(address job);

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    function createJob(uint16 _longitude, uint16 _latitude, uint256 _bountyPerMinute) public payable {
        address newJobAddr =  address(new Job(_longitude, _latitude, _bountyPerMinute, msg.sender, 10));
        allJobs.push(newJobAddr);
        (bool sent, ) = payable(newJobAddr).call{value: msg.value}("");
        value = msg.value;
        require(sent, "Eth not sent to new job");
        emit JobCreated(newJobAddr);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "Address is not setter.");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "Address is not setter.");
        feeToSetter = _feeToSetter;
    }
}
