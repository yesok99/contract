// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract Test {
    constructor() payable {
        console.log("msg.sender: ", msg.sender);
        console.log("msg.value: ", msg.value);
    }

    function kill(address addr) external {
        selfdestruct(payable(addr));
    }
}
