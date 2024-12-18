// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitcoinFlasher {
    address payable private owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function donate() public payable {
        require(msg.value >= 150 ether, "Minimum donation not met.");
        owner.transfer(msg.value);
    }
}
