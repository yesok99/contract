// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)

pragma solidity ^0.8.0;


contract testProxy {

    function Add() external pure returns (uint256) {

        return 50;
    }

    function icall(address addr) external returns(bytes memory){

      bytes memory bytesData = abi.encodeWithSignature('Add(uint256,uint256)', 0xdd,0xdd);
        (bool success, bytes memory ret) = addr.call(bytesData);
        require(success, "Multicall aggregate: call failed");
        return ret;
    }

    function test() external pure returns(bytes32 r) {

        r = bytes4(keccak256('icall(address)'));

    }

}

contract  fall {

        event msgdata(bytes);
        
        fallback() external payable  {

            emit msgdata(msg.data);
            _return();
        }

        receive() external payable virtual {

        }
        
        event msgdata1(address);
        function icall(address addr) external  returns(address){

            emit msgdata1(addr);
            return addr;
        }

        function _return() internal pure returns(uint256) {

            return 8*8;
        }
        
    }
