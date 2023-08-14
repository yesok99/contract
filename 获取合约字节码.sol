// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.12;

contract TT {

    //获取合约字节码
    bytes32  constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(test).creationCode));
    bytes constant byteCode = type(test).creationCode;

    function getCodeHash() external pure returns (bytes32, bytes memory) {

        return (INIT_CODE_PAIR_HASH, byteCode);
    }

}

contract test{

    function test1() external pure returns(bytes32  ret) {

        // bytes1 u1 = 0x99;
        // bytes32 u = bytes32(0x00);

        

        // assembly{
        
        //     ret := codesize()
       
        // }


    }

    function at(address _addr) public view returns (bytes memory o_code,uint256 r) {
        
        assembly {

            // 获得_addr地址的代码大小
            let size := extcodesize(_addr)
            //分配输出字节数组，也可以不使用汇编
            // o_code = new bytes(size)
            o_code := mload(0x40)
            // 包含补位的新内存块
            mstore(0x40, add(o_code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            // 存储长度
            mstore(o_code, size)
            // 获得代码
            extcodecopy(_addr, add(o_code, 0x20), 0, size)
            r := size
        }

    }
}