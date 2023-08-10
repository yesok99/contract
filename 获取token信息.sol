// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
interface iToken {
  
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    

}


contract TokenInfo {

    function getTokenInfo(address token) external view returns(string memory name, string memory symbol,uint8 decimals) {

            name = iToken(token).name();
            symbol = iToken(token).symbol();
            decimals = iToken(token).decimals();

    }
}

