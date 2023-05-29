//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "src/14_Gatekeeper_Two/Level.sol";
import "src/14_Gatekeeper_Two/Attacker.sol";

contract GatekeeperTwoTest is Test {

    GatekeeperTwo target = new GatekeeperTwo();


    function test_attack() public { 
        //The attack is in the constructor
        new Attacker(address(target));
        assertEq(msg.sender,target.entrant());
    }
    
}
