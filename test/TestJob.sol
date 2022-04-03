// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../contracts/Job.sol";
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

contract TestJob {

    Job job1;
    address owner;

    constructor() {
        owner = 0xCBf1079a4099Cf695F7dE4C481Ce6998F0fA9045;
    }

    function testCreateJob() public {
        uint16 _longitude = 54;
        uint16 _latitude = 54;
        uint256 _bountyPerMinute = 10;
        address _feeTo = 0xa26e4b13dd742bE0e551C8E1701c3C6eafe2607b;
        uint256 _feeRate = 10;
        job1 = new Job(_longitude, _latitude, _bountyPerMinute, owner, _feeTo, _feeRate);

        Assert.equal(job1.bountyPerMinute(), _bountyPerMinute, "should be equal");
    }

    function testContractorAcceptJob() public {
        job1.contractorAcceptJob();

        Assert.equal(address(this), job1.contractor(), "Contractor address is set to calling address");
    }

    function testContractorAcceptJobAgain() public {
        ThrowProxy throwproxy = new ThrowProxy(address(job1)); 

        Job(address(throwproxy)).contractorAcceptJob();

        bool r = throwproxy.execute();

        Assert.isFalse(r, "Should be false because is should throw!");
    }

}

contract ThrowProxy {
  address public target;
  bytes data;

  constructor(address _target) {
    target = _target;
  }

  function execute() returns (bool) {
    return target.contractorAcceptJob(data);
  }
}