pragma solidity ^0.4.25;

contract A {
  int public x1;
  int public x2;

  function inc_callcode(address _contractAddress) public {
      _contractAddress.callcode(bytes4(keccak256("inc()")));
  }
  function inc_delegatecall(address _contractAddress) public {
      _contractAddress.delegatecall(bytes4(keccak256("inc()")));
  }
  function inc_call(address _contractAddress) public {
      _contractAddress.call(bytes4(keccak256("inc()")));
  }
  function setB(address _contractAddress) public {

    B  setb = B(_contractAddress);
    setb.inc();

  }
}

contract B is A{
  int public x;

  event senderAddr(address);
  function inc() public {
      x++;
      emit senderAddr(msg.sender);
  }
}

contract A1 {
    address public temp1;
    uint256 public temp2;
    function three_call(address addr) public {
            addr.call(bytes4(keccak256("test()")));                 // 情况1
            addr.delegatecall(bytes4(keccak256("test()")));       // 情况2
            addr.callcode(bytes4(keccak256("test()")));           // 情况3   
    }
} 

contract B1 {
    address public temp1;
    uint256 public temp2;    
    function test() public  {
            temp1 = msg.sender;
            temp2 = 100;    
    }
}