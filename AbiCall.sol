// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.3;

contract A {
    event Log(string);
    function foo(uint a,uint b) external pure returns(uint) {

        return a*b;
    }

    fallback() external {
        emit Log("fallback");
    } 

}

contract testABI {
    
    uint storedData;
    bytes public calldata1;

    function set(uint x) public {
        storedData = x;
    }

    function abiEncode() public pure returns (bytes memory a, bytes memory b, bytes4 c) {
       a =  abi.encode(123);  // 计算1的ABI编码
       b = abi.encodeWithSignature("set(uint256)", 125,123); //计算函数set(uint256) 及参数1 的ABI 编码
       c = bytes4(keccak256("set(uint256)"));
    }

    function abiDecode() public pure returns (uint  m, uint u) {
       
        bytes memory data = abi.encode(0x60fe47b1, 256);
        (m, u) = abi.decode(data, (uint  , uint));

    }


    function callData(address _addr) external returns(uint u){
         //注意：参数必须是 uint256 而不是uint
         (bool success, bytes memory ret) = _addr.call(abi.encodeWithSignature("foo(uint256,uint256)",2,3));
        require(success, "call faile");
        calldata1 = ret;
        u = abi.decode(ret,(uint));
    }

    
}