// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

interface IERC20 {
    
    event Transfer(address indexed from, address indexed to, uint value);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
contract FlashSwap  {
    
    address public factory;
    address pair;
    address public token0;
    address public token1;
    // event pinkEimt(address sender, uint amount0, uint amount1, bytes  data);
    // event testflash(address token0,address token1, uint amount0, uint amount1, bytes  data);
    receive() external payable {}

    function test_fash(address _tokenBorrow, uint _amount) external  {


        // address token0 = IPinkswapPair(pair).token0();
        // address token1 = IPinkswapPair(pair).token1();
        uint amount0Out = (token0 == _tokenBorrow) ? _amount : 0;
        uint amount1Out = (token1 == _tokenBorrow) ? _amount : 0;
        bytes memory data = abi.encode(_tokenBorrow, _amount);
        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);
        // emit testflash( token0, token1,  amount0Out,  amount1Out,   data);
    }
    //uniswapV2Call
    function pinkswapCall(address sender, uint amount0, uint amount1, bytes calldata data) external  {
        
        { 

            (address _tokenBorrow, uint _amount) = abi.decode(data, (address, uint));
            uint fee = ((_amount * 301) / 99699) ;
            uint amount = _amount + fee ;
            IERC20(_tokenBorrow).transfer(pair, amount);
            // emit pinkEimt( sender,  amount0,  amount1,   data);
        }

        
    }

    function setTokenAddress(address _factory, address _token0, address _token1) external{

            factory = _factory;
            token0  = _token0;
            token1  = _token1;
            pair = IUniswapV2Factory(factory).getPair(token0, token1);
         
    }

    function addliquid(uint amount0, uint amount1, address to) external returns(uint liquidity) {
        
        
        IERC20(token0).transferFrom(msg.sender, pair, amount0);
        IERC20(token1).transferFrom(msg.sender, pair, amount1);
        liquidity = IUniswapV2Pair(pair).mint(to);
    }


    function getPairReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) {

        (reserve0, reserve1, blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
    }

    function batch(address token, address to, uint amount) external {
        for (uint i;i<200;i++) {
            IERC20(token).transferFrom(msg.sender,to,amount);
        }

    }
    
    function batch1(address token, address to, uint amount) external {
        
            IERC20(token).transferFrom(msg.sender,to,amount);


    }   
}