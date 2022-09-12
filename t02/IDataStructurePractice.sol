// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.12;

import "@openzeppelin/contracts/access/Ownable.sol"; 


interface IDataStructurePractice {
    struct User {
        string name;
        uint256 balance;
        bool isActive;
    }

    function setNewUser(address _userAdr, User calldata _newUser) external;
    function getUser(address _user) external view returns(User memory);
    function getMyInfo() external view returns(User memory);
}

contract Task2 is IDataStructurePractice, Ownable{
    constructor(){
        super;
    }
    mapping(address => User) users;

    function setNewUser(address _userAdr, User calldata _newUser) onlyOwner external {
        users[_userAdr] = _newUser;
    }
    function getUser(address _user) external view returns(User memory) {
        return users[_user];
    }

    function getMyInfo() external view returns(User memory) {
        return users[msg.sender];
    }
}
