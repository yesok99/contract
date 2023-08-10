//判断一个地址是否为合约地址或是外部账户地址

//extcodesize

//获取地址关联代码长度。 合约地址长度大于0， 外部账户地址为0


//pragma solidity ^0.4.18;
//extcodesize获取地址关联代码长度 合约地址大于0 外部账户地址为0 

contract IsCadd {
    function isContract(address addr) returns (bool) {
    uint size;
    assembly { size := extcodesize(addr) }
    return size > 0;
  }
}
