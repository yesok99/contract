分投趣合约：https://www.bscscan.com/address/0x29825cb9813cdc1837147ccb0a20b135ec7a591a#code

function _validSignature(
        address erc20Contract,
        address destination,
        uint256 value,
        uint8[] calldata vs,
        bytes32[] calldata rs,
        bytes32[] calldata ss
    ) private view returns (bool) {
        bytes32 message = _messageToRecover(erc20Contract, destination, value);
        return _validMsgSignature(message, vs, rs, ss);
    }
    
 function _messageToRecover(address erc20Contract, address destination, uint256 value) private view returns (bytes32) {
        bytes32 hashedUnsignedMessage = generateMessageToSign(erc20Contract, destination, value);
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        return keccak256(abi.encodePacked(prefix, hashedUnsignedMessage));
    }
    
function generateMessageToSign(address erc20Contract, address destination, uint256 value) private view returns (bytes32) {
        require(destination != address(this));
        //the sequence should match generateMultiSigV2 in JS
        bytes32 message = keccak256(abi.encodePacked(address(this), erc20Contract, destination, value, spendNonce));
        return message;
    }
    
    
function _validMsgSignature(
        bytes32 message,
        uint8[] calldata vs,
        bytes32[] calldata rs,
        bytes32[] calldata ss
    ) private view returns (bool) {
        require(vs.length == rs.length);
        require(rs.length == ss.length);
        require(vs.length <= owners.length);
        require(vs.length >= required);
        address[] memory addrs = new address[](vs.length);
        for (uint i = 0; i < vs.length; i++) {
            //recover the address associated with the public key from elliptic curve signature or return zero on error
            addrs[i] = ecrecover(message, vs[i] + 27, rs[i], ss[i]);
        }
        require(_distinctOwners(addrs));
        return true;
    }
    
    function _distinctOwners(address[] memory addrs) private view returns (bool) {
        if (addrs.length > owners.length) {
            return false;
        }
        for (uint i = 0; i < addrs.length; i++) {
            if (!isOwner[addrs[i]]) {
                return false;
            }
            //address should be distinct
            for (uint j = 0; j < i; j++) {
                if (addrs[i] == addrs[j]) {
                    return false;
                }
            }
        }
        return true;
    }
