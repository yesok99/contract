
// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.12;

contract ChenckContract {
    function isContract(address addr) external view returns (bool) {
    uint size;
    assembly { size := extcodesize(addr) }
    return size > 0;
  }
}

