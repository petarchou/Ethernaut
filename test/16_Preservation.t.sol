//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "src/16_Preservation/Level.sol";
import "src/16_Preservation/Attacker.sol";

contract PreservationTest is Test {

    LibraryContract lib1 = new LibraryContract();
    LibraryContract lib2 = new LibraryContract();

    Preservation target = new Preservation(address(lib1), address(lib2));
    Attacker attacker = new Attacker(address(target));

    function test_attack() public {
        address sender = makeAddr("sender");
        attacker.attack();
        address owner = target.owner();
        assertEq(sender, owner);
        
    }
   
    
}
