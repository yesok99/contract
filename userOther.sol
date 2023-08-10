// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.4.23;
contract A {
    address private bAddress;
    B bContract;
    constructor(address baddr) public{
       bContract = B(baddr); // 转换地址为合约类型
    }
    
    function callHello() external view returns(string memory){
    //    B b = B(bAddress); // 转换地址为合约类型
       return bContract.sayHello();
    }
    function setAstring(string str) public{
        // B b = B(bAddress); // 转换地址为合约类型
        bContract.setString(str);
    }

    function greeting1() public view returns(string str){
        // B b = B(bAddress); // 转换地址为合约类型
        str = bContract.greeting();
    }

}

contract B {
     string public greeting = "hello world";
     address owner = msg.sender;
     function sayHello() external view returns(string memory){
         return greeting;
     }
     function setString(string str) public{
        //  require(owner == msg.sender,"没有修改权限");
         greeting = str;
     }
}
