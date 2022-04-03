// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Test {

    string testowner;

    constructor(
        string memory _test
    ) {
        testowner = _test;
    }

    function myFunction(uint256 test) public pure returns(uint256){
        return test;
    }
}