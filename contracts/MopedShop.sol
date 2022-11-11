// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MopedShop {
    mapping (address => bool) buyers;
    bool public fullPaid;
    uint public price = 2 ether;
    address public owner;
    address public shopAddress;

    event ItemFullPaid(uint _price, address _shopAddress);

    constructor() {
        owner = msg.sender;
        shopAddress = address(this);
    }

    function getBuyer(address _addr) public view returns(bool){
        require(owner == msg.sender, "You aren't an owner!");

        return buyers[_addr];
    }

    function addBuyer(address _addr) public {
        require(owner == msg.sender, "You aren't an owner!");

        buyers[_addr] = true;
    }

    function getBalance() public view returns(uint) {
        return shopAddress.balance;
    }

    function withdrawAll() public {
        require(owner == msg.sender && fullPaid && shopAddress.balance > 0, "Rejected");

        address payable receiver = payable(msg.sender);

        receiver.transfer(shopAddress.balance);
    }

    receive() external payable {
        require(buyers[msg.sender] && msg.value <= price && !fullPaid, "Rejected");

        if(getBalance() == price) {
            fullPaid = true;

            emit ItemFullPaid(price, shopAddress);
        }
    }
}