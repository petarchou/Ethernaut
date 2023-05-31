// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract Dex is Ownable {
  address public token1;
  address public token2;
  constructor() {}

  //A function which sets the token addresses, only callable by owner
  function setTokens(address _token1, address _token2) public onlyOwner {
    token1 = _token1;
    token2 = _token2;
  }
  
  //another onlyOwner function - useless
  function addLiquidity(address tokenAddress, uint amount) public onlyOwner {
    IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
  }
  
  function swap(address from, address to, uint amount) public {
    //require to be using the 2 defined tokens
    require((from == token1 && to == token2) || (from == token2 && to == token1), "Invalid tokens");
    //msg.sender should have >= balance of the "from" token
    require(IERC20(from).balanceOf(msg.sender) >= amount, "Not enough to swap");

    //Swap amount calculation
    uint swapAmount = getSwapPrice(from, to, amount);
    //transfer from sender to contract "amount" tokens
    IERC20(from).transferFrom(msg.sender, address(this), amount);
    IERC20(to).approve(address(this), swapAmount);
    IERC20(to).transferFrom(address(this), msg.sender, swapAmount);
  }

  function getSwapPrice(address from, address to, uint amount) public view returns(uint){
    //amount of "from" tokens * contract balance of "to" tokens / balance of "from" tokens
    //Example: trade 10 token1 - 10 * 100/10 = 10 tokens (110 token1 | 90 token2)
    //Then trade 20 token2 -  20 * 100 / 90 = 22.2 (22)
    //EXPLOIT: Keep trading tokens and make use of vulnerable swaps to drain the balance token
    return((amount * IERC20(to).balanceOf(address(this)))   /    IERC20(from).balanceOf(address(this)));
  }

  function approve(address spender, uint amount) public {
    SwappableToken(token1).approve(msg.sender, spender, amount);
    SwappableToken(token2).approve(msg.sender, spender, amount);
  }

  function balanceOf(address token, address account) public view returns (uint){
    return IERC20(token).balanceOf(account);
  }
}

contract SwappableToken is ERC20 {
  address private _dex;
  constructor(address dexInstance, string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _dex = dexInstance;
  }

  function approve(address owner, address spender, uint256 amount) public {
    require(owner != _dex, "InvalidApprover");
    super._approve(owner, spender, amount);
  }
}