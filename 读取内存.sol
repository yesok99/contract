// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.12;

/*

store存储位置：
  web3.utils.keccak256(web3.eth.abi.encodeParameter('uint256',N))
  keccak256(abi.encodePacked(Ns))
N为第N个变量

  map(uint=>utint) test;
  map(key,val)
  keccak256(abi.encodePacked(key, slot_position));
  slot_position 值为第几个 slot_position 个变量

  bytes类型 
    bytes testArray = "aaaaaaaaaaabbbbbbbbbbbbbbbbcccccccccccccccccccaaaaaaaaaaaaaa";

    假设testArray为第二个变量：
    testArray 长度的位置：pos = keccak256(abi.encodePacked(2))
    第一个数位置：keccak256(abi.encodePacked(pos))
    第N个数位置： keccak256(abi.encodePacked(pos + N - 1))

web3 获取内存位置
const Web3 = require('web3');
const rpcURL = "https://rinkeby.infura.io/v3/2ab0c9f096474b2a8b7b60a25ded6c21";
const web3 = new Web3(rpcURL);
const address = "0xc4953C978c8339d62730B602E1Fbe46CFddC9f02"
web3.eth.getStorageAt(address,"18569430475105882587588266137607568536673111973893317399460219858819262702947",function(x,y){console.info(y);});

web3.eth.getStorageAt(address, position [, defaultBlock] [, callback])
web3.eth.getStorageAt("0x407d73d8a49eeb85d32cf465507dd71d507100c1", 0)
.then(console.log);
原文链接：https://blog.csdn.net/rfrder/article/details/115706983
*/

contract AssemblyArrays {

  uint128 public A = 1;// 16 bytes

    uint96 public B = 2; // 12 bytes

    uint16 public C = 4; // 2 bytes

    uint8   public D= 5; // 1 bytes

    bool public E = true; // 1 bytes 
    
    // sum in a slot 0 = 32 bytes

    function loadYulSlotInBytes(uint256 slot) external view returns(bytes32 ret) {

        assembly {

            ret := sload(slot)
            ret := shr(mul(D.offset,8),ret)
        }
    }
  
  struct AddressSlot {
        address value;

    }
  uint[] test = [1,2,3];
  //bytes testArray = "aaaaaaaaaaabbbbbbbbbbbbbbbbcccccccccccccccccccaaaaaaaaaaaaaa";
  bytes testArray = "aabb";
  mapping(uint => uint) public testMap;
  bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;


  
  function addMap(uint key) public {
      testMap[key] = key + 1;
  }
  
  //即使存储位置, slot_position为第几个slot
  function getMapaddress(uint key, uint slot_position) public pure returns(bytes32 res) {
      res = keccak256(abi.encodePacked(key, slot_position));
  }

  function getMap(uint x) public view returns(uint) {

    uint r = testMap[x];
    return r;

  }

  function addressVal(bytes32 pos) external view returns(bytes32 ret) {

    assembly{

      ret := sload(pos)
    }
  
  }

  function demoString() external pure returns( string memory  ) {

    bytes memory t = '1a23';
    bytes32   demo ="";

      assembly {

        demo := "Hello World"
        demo := "abc"

      }


      return string(abi.encode (t) ) ;

  }

      
 
//   function getLength() public view returns (uint256) {
//       return testArray.length;
//   }

  function getLength() public view returns (uint256, bytes memory) {
      bytes memory memoryTestArray = testArray;
      uint256 result;
      assembly {
          result := mload(memoryTestArray)
      }
    return (result, memoryTestArray);
  }
  
  function getElement(uint256 index) public view returns (bytes1) {
      return testArray[index];
  }
  
  function pushElement(bytes1 value) public {
      testArray.push(value);
  }
  
  function updateElement(bytes1 value, uint256 index) public {
      testArray[index] = value;
  }

  function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        /// @solidity memory-safe-assembly
        assembly {
            r.slot := slot

        }
       
  }

  function getImplementation() internal  view returns (address){

    return  getAddressSlot(_IMPLEMENTATION_SLOT).value;

  }

  function setImplementation(address _Implementation) external {

      getAddressSlot(_IMPLEMENTATION_SLOT).value = _Implementation;
  }


  function doSomething() public pure returns(bytes memory encodeWithSignature ,bytes memory encodeWithSelector, bytes memory encode,bytes memory encodepack) {
 
    //  bytes memory r = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaAA';

    encodeWithSignature = abi.encodeWithSignature("doSomething(string,string)", "hello","aaa");
    encodeWithSelector = abi.encodeWithSelector(bytes4(keccak256("doSomething(string,string)")),"hello","aaa"); 
    encode = abi.encode(1,2,"hello");
    encodepack = abi.encodePacked(uint(0x1),uint(0x2),string('hello'),string('world'));


    // return (r0,r1);


    // assembly{

    //     mstore(0x80,0x20)
    //     mstore(0xa0,0x05)  // five sizes of hello
    //     mstore(0xc0,"helloo")

    //     return(0x80,0x60) // total 0x60 bytes

    // }
  }

  function doMemory() external pure returns(string memory ret) {

      assembly{

        ret := mload(0x40) //给空闲指针
      
        mstore(ret, 0x20) // ret数据长度
        
        mstore(add(ret,0x20), 0x0c) // ret数据长度
     
        mstore(add(ret,0x40), "hello world") //ret 数据

        mstore(0x40,add(ret,0x60))

        return(ret, add(0x20,0x60))
      }
     
  }
    

}
