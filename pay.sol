// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

contract testPay{
    uint256 amount = 0;
    mapping(address => uint256) balances;
    event showinfo(uint256 account_total_balance,uint256 msgsend_balance,uint256 account_num);
    
    function deposit() public payable{
        balances[msg.sender] += msg.value; 
        amount++;
        emit showinfo(address(this).balance,balances[msg.sender],amount);
    }

    function withdraw(uint money) public {
        uint256 _money = money * 10**18;
        require(balances[msg.sender] >= _money,"Not enough money");
        payable(address(msg.sender)).transfer(_money);
        balances[msg.sender] -= _money;
        emit showinfo(address(this).balance,balances[msg.sender],amount);
        
    }

    function viewinfo() public view returns(uint,uint,address,uint){
        //emit showinfo(address(this).balance,balances[msg.sender],amount);
        return (balances[msg.sender],amount,address(msg.sender),address(this).balance);
    }

    
}

contract attack {
    testPay tpay;

    constructor(address addr) {

         tpay = testPay(addr);

    }
    
    function deposit() public payable{
        require(msg.value >= 1 ether);
        tpay.deposit{value:1 ether}();

    }
    
    function showinfo() public view returns(uint,uint,address,uint){

    //    tpay.withdraw(val);
       return tpay.viewinfo();
    }

    function Iwithdraw(uint val) public {

       tpay.withdraw(val);
    }

    function showAddress() public view returns(address){
        return msg.sender;
    }
    receive() external payable {

    }
}