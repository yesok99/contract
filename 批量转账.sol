// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

interface IERC20 {
    
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

contract batch  {
    
    function batchTransfer(address token, address to, uint amount, uint times) external {
        for (uint i; i < times; i++) {
            
            IERC20(token).transferFrom(msg.sender,to,amount);
        }

    }

    function transfer(address token, address to, uint amount) external {

        IERC20(token).transfer(to, amount);

    }

    function approve(address token, address to, uint amount) external {

        IERC20(token).approve(to, amount);

    }
        
    function balanceOf(address token, address owner) external view returns (uint ){

        return  IERC20(token).balanceOf(owner);
    }
}