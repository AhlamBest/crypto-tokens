// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract Token {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply = 10000 * 10 ** 18; // Total supply of tokens
    string public name = "My Token"; // Token name
    string public symbol = "MT"; // Token symbol
    uint8 public decimals = 18; // Number of decimal places for token

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balances[msg.sender] = totalSupply; // Assign total supply to contract deployer
    }

    // Function to get the balance of an address
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }

    // Function to transfer tokens
    function transfer(address to, uint value) public returns(bool) {
        require(to != address(0), "Invalid recipient"); // Prevent transferring to zero address
        require(balanceOf(msg.sender) >= value, 'Insufficient balance');
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    // Function to transfer tokens from one address to another with approval
    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(from != address(0), "Invalid sender"); // Prevent transferring from zero address
        require(to != address(0), "Invalid recipient"); // Prevent transferring to zero address
        require(balanceOf(from) >= value, 'Insufficient balance');
        require(allowance[from][msg.sender] >= value, 'Allowance too low');
        balances[to] += value;
        balances[from] -= value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    // Function to approve spending allowance to another address
    function approve(address spender, uint value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // Function to increase allowance
    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
        allowance[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    // Function to decrease allowance
    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        uint currentAllowance = allowance[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "Decreased allowance below zero");
        allowance[msg.sender][spender] -= subtractedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }
}
