
// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.12;

interface ERC20Interface {
    function balanceOf(address user) external view returns (uint256);
    function transfer(address dst, uint wad) external returns (bool);
}

contract withdraw {

address public owner;
constructor() {
    owner = msg.sender;
}
function withdrawToken(address token, address to) external onlyOwner {
        uint256 balance = ERC20Interface(token).balanceOf(address(this));
        _safeTransfer(token,to,balance);
    }

    function _safeTransfer(address token, address to, uint256 value) internal {
        // (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        // require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
        ERC20Interface(token).transfer(to, value);
    }

function setower(address newower) external onlyOwner {
    owner = newower;
}
modifier onlyOwner() {
        require(owner == msg.sender, "MinterAccess: sender do not have the minter role");
        _;
    }

}