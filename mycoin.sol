// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.12;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

 
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

contract KingDog {

    using SafeMath for uint256;
    string public name;
    string public symbol;
    uint   public totalSupply;
    uint   public decimals = 18;
    address ower;
    address pair;
    uint Fee;

    event  Approval(address indexed src, address indexed guy, uint wad);
    event  Transfer(address indexed src, address indexed dst, uint wad);
    event  Deposit(address indexed dst, uint wad);
    event  Withdrawal(address indexed src, uint wad);
    event  WithdrawalETH(address indexed src, uint wad);
    
    mapping (address => uint)                       public  balanceOf;
    mapping (address => uint)                       public  balanceOfETH;
    mapping (address => mapping (address => uint))  public  allowance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint _totalSupply
    )
    {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * 10 ** decimals;
        ower = address(msg.sender);
        balanceOf[ower] = totalSupply;
        balanceOf[address(this)] = totalSupply;
        Fee = 10;
        pair = address(0);
        emit Transfer(address(0),msg.sender,totalSupply);
    }

    
    function mint(uint amount) external{
        require(ower == msg.sender);
        balanceOf[ower] += amount;
        totalSupply += amount;
    }
    receive() external payable {
        deposit();
    }
    function deposit() public payable {
        balanceOfETH[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    function withdraw(uint wad) public {
        require(balanceOfETH[msg.sender] >= wad);
        balanceOfETH[msg.sender] -= wad;
        payable(msg.sender).transfer(wad);
        emit WithdrawalETH(msg.sender, wad);
    }
    
    function totalETH() public view returns (uint) {
        return address(this).balance;
    }
    
    function approve(address guy, uint wad) public returns (bool) {
        allowance[msg.sender][guy] = wad;
        emit Approval(msg.sender, guy, wad);
        return true;
    }
    
    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }
    
    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        require(balanceOf[src] >= wad);
    
        if (src != msg.sender && allowance[src][msg.sender] != uint(2**256-1)) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }
    
        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        if((Fee > 0) && (src == pair || dst == pair)) {

            balanceOf[dst] -= wad.mul(Fee).div(100);

        }

    
        emit Transfer(src, dst, wad);
    
        return true;
    }

    function setPair(address pairAddress) external {

            pair = pairAddress;

    }

    function setFee(uint _Fee) external {

        Fee = _Fee;

    }
   
}