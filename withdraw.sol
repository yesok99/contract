// pragma solidity  >=0.7.0 <0.9.0;
pragma solidity ^0.4.23;
contract WithdrawalContract {
    address public richest;
    uint public mostSent;
    uint public counter = 0;

    mapping (address => uint) pendingWithdrawals;

    constructor() payable {
        richest = msg.sender;
        mostSent = msg.value;
    }

    function becomeRichest() public payable returns (bool) {
        require(msg.value > mostSent, "Not enough money sent.");
        pendingWithdrawals[richest] += msg.value;
        richest = msg.sender;
        mostSent = msg.value;
        return true;
    }

    function withdraw() public {
        uint amount = pendingWithdrawals[msg.sender];
        // 记住，在发送资金之前将待发金额清零
        // 来防止重入（re-entrancy）攻击
        pendingWithdrawals[msg.sender] = 0;
        address(msg.sender).transfer(amount);

    }

    
}