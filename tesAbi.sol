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
    //    c = bytes4(keccak256("set(uint256)"));
    c = bytes4(keccak256("withdrawRewards(address,address,uint256,uint256,uint8,bytes32,bytes32)"));

       b = abi.encodeWithSignature(
           "swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256,uint256,address[],address,uint256)",
           100000000000000000000,
           1,
           [0x3b9661287c23E1Ea44EEb1c2a606b51432D70863,0x55d398326f99059fF775485246999027B3197955],
        0xd30Fa7f4F7748636a0434E73c00fF1FEc64EC679,
           1657275067
       );
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