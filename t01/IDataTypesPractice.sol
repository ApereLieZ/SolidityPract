// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

interface IDataTypesPractice {
    function getInt256() external view returns(int256);
    function getUint256() external view returns(uint256);
    function getIint8() external view returns(int8);
    function getUint8() external view returns(uint8);
    function getBool() external view returns(bool);
    function getAddress() external view returns(address);
    function getBytes32() external view returns(bytes32);
    function getArrayUint5() external view returns(uint256[5] memory);
    function getArrayUint() external view returns(uint256[] memory);
    function getString() external view returns(string memory);

    function getBigUint() external pure returns(uint256);
}

contract Task1 is IDataTypesPractice{

    int256 Int256 = 123124123; 
    uint256 Uint256 = 124124;
    int8 Int8 = 12;
    uint8 Uint8 = 13;
    bool Bool = true;
    address Address = address(23);
    bytes32 Bytes32 = "Hello bytes";

    uint[5] UintArray5 = [1, 2, 3,4,88];
    uint[] UintArray = [31, 2, 3,4,88,4 ,34,3,2];

    string String = "Hello World!";

    function getBigUint() external pure returns(uint256) {
        uint256 v1 = 1;
        uint256 v2 = 2;
        return (v2**((v2 * (v2 + v2)) << v2))/ v1;
    }

    function getInt256() external view returns(int256) {
        return Int256;
    }

    function getUint256() external view returns(uint256) {
        return Uint256;
    }

    function getIint8() external view returns(int8) {
        return Int8;
    }

    function getUint8() external view returns(uint8) {
        return Uint8;
    }

    function getBool() external view returns(bool) {
        return Bool;
    }

    function getAddress() external view returns(address){
        return Address;
    }

    function getBytes32() external view returns(bytes32){
        return Bytes32;
    }

    function getArrayUint5() external view returns(uint256[5] memory) {
        return UintArray5;
    }

    function getArrayUint() external view returns(uint256[] memory) {
        return UintArray;
    }

    function getString() external view returns(string memory) {
        return String;
    }
}