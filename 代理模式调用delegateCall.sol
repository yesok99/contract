// SPDX-License-Identifier: MIT
pragma solidity ^ 0.8 .0;

// import "./Proxy.sol";

/**
 * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
 * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
 * be specified by overriding the virtual {_implementation} function.
 *
 * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
 * different contract through the {_delegate} function.
 *
 * The success and return data of the delegated call will be returned back to the caller of the proxy.
 */
abstract contract Proxy {
    /**
     * @dev Delegates the current call to `implementation`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */
    function _delegate(address implementation) internal virtual {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    /**
     * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
     * and {_fallback} should delegate.
     */
    function _implementation() internal view virtual returns (address);

    /**
     * @dev Delegates the current call to the address returned by `_implementation()`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */
    function _fallback() internal virtual {
        _beforeFallback();
        _delegate(_implementation());
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
     * function in the contract matches the call data.
     */
    fallback() external payable virtual {
        _fallback();
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
     * is empty.
     */
    receive() external payable virtual {
        _fallback();
    }

    /**
     * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
     * call, or as part of the Solidity `fallback` or `receive` functions.
     *
     * If overridden should call `super._beforeFallback()`.
     */
    function _beforeFallback() internal virtual {}
}

contract testProxy is Proxy {

    uint256 public x = 1;

    address implementation ;

    // constructor(address logic) {

    //     implementation = logic;
    // }

    function _implementation() internal view virtual override returns (address impl) {

        return implementation;      
    
    }

    function setImplementation(address Logic) external {

        implementation = Logic;
    }

}

contract Caller {

    // uint256 public x = 1;
    string public retBytes;
    bytes public retBytes1;
    uint256 public u;
    function callTest(testProxy test) public  {
        (bool success, bytes memory r) = address(test).call(abi.encodeWithSignature("doSomething()"));
        require(success);
        // retBytes = r;

       (retBytes,  u) = abi.decode(r, (string,uint256));
       retBytes1 = r;

    }

    function _delegate(address implementation) internal virtual {

        // bytes memory _calldata =  abi.encodeWithSelector(bytes4(keccak256("doSomething")), implementation);
        
        // uint len = _calldata.length;

        //bytes memory _calldata = '1354f1020000000000000000000000005a86858aa3b595fd6663c2296741ef4cd8bc4d01';
        assembly {


            
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    function getMemory(address implementation) public pure returns(bytes memory,uint) {

        bytes memory _calldata =  abi.encodeWithSelector(bytes4(keccak256("doSomething")), implementation);
        
        return (_calldata, _calldata.length);
    }
}

contract Target {

  uint256 public x = 5;
  function doSomething() public  returns(string memory ,uint256) {
 
     bytes memory r = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaAA';

     r = "hello" ;
    // assembly{

    //     mstore(0x80,0x20)
    //     mstore(0xa0,0x05)  // five sizes of hello
    //     mstore(0xc0,"helloo")

    //     return(0x80,0x60) // total 0x60 bytes

    // }
    x = x * 2;
    return (string(r),x);
  
  }

}

//先部署 Target =》 testProxy =〉Caller
