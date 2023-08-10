
// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.12;
contract VerfySig {
	function verify(address _signer, string memory _message, bytes memory _sig)
		external pure returns (bool)
	{
		bytes32 messageHash = getMessageHash(_message);
		bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
		
		return recover(ethSignedMessageHash, _sig) == _signer;
	}
	
	function getMessageHash(string memory _message) public pure returns (bytes32) {
		return keccak256(abi.encodePacked(_message));
	}
	
	function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
	}
	
	function recover(bytes32 _ethSignedMessageHash, bytes memory _Sig) public pure returns (address) {
		
		(bytes32 r, bytes32 s, uint8 v) = _split(_Sig);
		return ecrecover(_ethSignedMessageHash, v, r, s);
	}
	
    function _split(bytes memory sig) internal pure returns(bytes32 r, bytes32 s, uint8 v) {
		
        require(sig.length == 65, "invalid signature length");
        assembly{
			r := mload(add(sig, 32))
			s := mload(add(sig, 64))
			v := byte(0,mload(add(sig, 96)))
		}
	}
	
    //恢复签名
    // 1、控制台上执行：ethereum.enalbe(); //打开metamask
    // 2、account = "0xf45eF91259ADdBB5f57a44B4b75E3435d03136c3";
    //3、getMessageHash("secret message"),结果 ：bytes32: 0x9c97d796ed69b7e69790ae723f51163056db3d55a7a6a82065780460162d4812
    //4、 var hash = "0x9c97d796ed69b7e69790ae723f51163056db3d55a7a6a82065780460162d4812"；
    //5、
    //account = "0xf45eF91259ADdBB5f57a44B4b75E3435d03136c3";
    //hash = "0x9c97d796ed69b7e69790ae723f51163056db3d55a7a6a82065780460162d4812";
    // let sig = await ethereum.request({method:"personal_sign",params: [account,hash]})
    //sig = '0x0dff23376ec8c56d1f4feb0e0f15c3448946fa6d8690ffb3b4cc0661958bc04b547d23a94e13982e98dbd01cc180902033cfadb404bafe2b850ad5f1c3c66f3a1b'
}

