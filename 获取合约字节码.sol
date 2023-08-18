// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.12;

contract getByteCode {

    //获取合约字节码
    bytes32  constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(test).creationCode));
    bytes constant byteCode = type(test).creationCode;

    function getCodeHash() external pure returns (bytes32, bytes memory) {

        return (INIT_CODE_PAIR_HASH, byteCode);
    }

}

contract test{

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
            r := extcodesize(_addr)
        }

    }

    function asm(uint x) external pure returns(bytes32 r) {

        //bytes32 x = 0x0000000000000000000000000000000000000000000000000000000000000040;
        assembly{
            r := mload(x)

        }
        

    }

   

    function _mStore() external pure returns (string memory ret){

        
        // bytes memory m = "999999999999999999988888888888888888885555555555555555557777777777777777777777766666666666666666666666666666666666";
        bytes memory m1 = "AAAAAA";
        // bytes memory m = "1234567890123456789012345678901234567890";
        // bytes memory m1 = "bb";
        assembly{
            
            // mstore8(0, 1)
            // mstore8(8, 2)
            // mstore8(16, 3)
            // mstore(x, y)
            // ret := mload(x)
            // ret := add(0,mload(m1)) //m1 位内存偏移offset m1大小 = mload(m1) ,m1内容 = mload(add(m1+32))...
            // return(0x80,32)

            
            mstore(add(m1,0x40),mload(add(m1,0x20))) //数据内容
            mstore(add(m1,0x20),mload(m1)) // 数据的长度
            mstore(m1,0x20) // 数据的其实位置00x20
            mstore(0x40,add(m1,0x60)) //恢复内存指针
            
            return(m1,add(0x40,0x20))
            //bytes 类型返回值：数据位置(0x20 32为) + size(32位) + 数据内容(不小于32位)

        }
    }

}
