// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Test {

    address public owner; 
    uint public x;

    constructor(uint _x) {

        owner = msg. sender;

        x = _x;
    }

    function kill(address addr) external {
        selfdestruct(payable(addr));
    }

}

// 合约工厂

 contract TestFactory {

    Test[] public addrs; // function create(uint _x) external
    Test public addr;

    function creat(uint _x) external {
        addr = new Test(_x);
        addrs.push(addr);
    }

    function creats() external {

        for(uint i=0;i<100;i++) {
            addrs.push(new Test(i));
        }

    }
    function showAddress() external  view returns(Test[] memory, uint256){
        return (addrs, addrs.length);
    }

    // creat2 部署合约

    event Deploy (address addr);

    function deploy(uint _salt, uint _x) external {

        Test _contract = new Test{salt: bytes32(_salt)}(_x); 
        require(getNewAddr(getBytecode(_x), _salt) == address(_contract),'address error');
        addr = _contract;
        emit Deploy (address(_contract)) ;

    }

    function getBytecode(uint _x) public pure returns(bytes memory) {

        bytes memory bytecode = type(Test). creationCode; 
        return abi. encodePacked(bytecode, abi.encode(_x) ) ; 

    }

    function getNewAddr(bytes memory bytecode, uint _salt) public view returns(address) {

        bytes32 hash = keccak256(

            abi. encodePacked(
                bytes1(0xff),
                address(this), // 
                _salt,
                keccak256(bytecode) //hash
            )
        );

        return address(uint160(uint(hash)));
    }


 }