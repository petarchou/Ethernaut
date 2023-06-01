// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../helpers/UpgradableProxy.sol";

contract PuzzleProxy is UpgradeableProxy {
    address public pendingAdmin;
    address public admin;

    constructor(address _admin, address _implementation, bytes memory _initData) UpgradeableProxy(_implementation, _initData) {
        admin = _admin;
    }

    modifier onlyAdmin {
      require(msg.sender == admin, "Caller is not the admin");
      _;
    }

    //@audit proposeNewAdmin actually changes the owner - try to abuse owner
    function proposeNewAdmin(address _newAdmin) external {
        pendingAdmin = _newAdmin;
    }

    function approveNewAdmin(address _expectedAdmin) external onlyAdmin {
        require(pendingAdmin == _expectedAdmin, "Expected new admin by the current admin is not the pending admin");
        admin = pendingAdmin;
    }

    function upgradeTo(address _newImplementation) external onlyAdmin {
        _upgradeTo(_newImplementation);
    }
}

contract PuzzleWallet {
    //@audit-issue owner is a contract
    //@audit-issue contract uses a proxy and storage layouts don't match - can easily change owner
    address public owner;
    //@audit change maxBalance via proxy will actually change the 
    uint256 public maxBalance;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;

    function init(uint256 _maxBalance) public {
        //@audit-issue change max balance = reinitialize the contract = change owner
        require(maxBalance == 0, "Already initialized");
        maxBalance = _maxBalance;
        owner = msg.sender;
    }

    modifier onlyWhitelisted {
        require(whitelisted[msg.sender], "Not whitelisted");
        _;
    }
    //@audit-issue make current balance 0 = make maxBalance 0 = change the owner
    //@audit-step 5 call setMaxBalance by having encoded a new owner in the int
    function setMaxBalance(uint256 _maxBalance) external onlyWhitelisted {
      require(address(this).balance == 0, "Contract balance is not 0");
      maxBalance = _maxBalance;
    }

    //@audit 2 Add myself to whitelist
    //@audit-info only owner can whitelist - Need to become owner
    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not the owner");
        whitelisted[addr] = true;
    }

    //@audit-step have to deposit once but make it increase my balance twice
    function deposit() external payable onlyWhitelisted {

        //@audit-info can go over the maxBalance
      require(address(this).balance <= maxBalance, "Max balance reached");
      balances[msg.sender] += msg.value;
    }

    //@audit-step 4 withdraw all the money from the contract
    function execute(address to, uint256 value, bytes calldata data) external payable onlyWhitelisted {
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        //Abuse that I can choose which contract to call
        (bool success, ) = to.call{ value: value }(data);
        require(success, "Execution failed");
    }

    //@audit-step 3 send a multicall with 1 deposit and 1 nested multicall which calls deposit - to increase my balance twise
    function multicall(bytes[] calldata data) external payable onlyWhitelisted {
        bool depositCalled = false;
        //Iterate through data at every index and delegate the call to some of the other exisitng functiosn
        //Perform 1 transaction for multiple calls
        for (uint256 i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;

            assembly {
                //Apparently this get the function signature, not sure how exactly
                selector := mload(add(_data, 32))
            }
            // we can call deposit through execute multiple times
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                // Protect against reusing msg.value
                depositCalled = true;
            }
            //Delegate call to yourself???
            (bool success, ) = address(this).delegatecall(data[i]);
            require(success, "Error while delegating call");
        }
    }
}