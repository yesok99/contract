pragma solidity ^0.4.23;



contract Money {
    uint public  a;
    address public b;
    address public thisaddress;
    uint public c;
    uint public value;

    function getinfo() public payable{
        a = (msg.sender).balance;
        b = msg.sender;
        c = address(this).balance;
        thisaddress = this;

    }
    
    event AddressBalanceShow(address current_address, uint256 current_account_address_balance,uint256 contract_account_balance);
    
    constructor() public payable {
       emit AddressBalanceShow(msg.sender, address(msg.sender).balance, address(this).balance);
    }
    
    
    function deposit() public payable {
        // this.transfer(99);
        // emit Transfer(this,99) ;
        emit AddressBalanceShow(msg.sender, address(msg.sender).balance, address(this).balance);
    }
    
    function withdrawball(uint256 _value) public payable {
        msg.sender.transfer(_value);
        emit AddressBalanceShow(msg.sender, address(msg.sender).balance, address(this).balance);
        // a = address(msg.sender).balance;

    }
    
}