// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() { //177 gas
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    // last 4 bytes of gatekey == last 2 bytes of gatekey
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      //the last 4 bytes != all 8 bytes of gatekey - implicit
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      //last 4 bytes of _gatekey == last 2 bytes of tx.origin 00 00 00 00   00 00 00 11
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");

    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo returns (bool) {
    entrant = tx.origin;
    return true;
  }
}