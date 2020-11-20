// SPDX-License-Identifier: MIT
pragma solidity ^0.6.5;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

// https://ethereum.stackexchange.com/questions/10864/erc20-token-and-effective-way-to-store-dividends

/// @author SJS
/// @title Manages ERC20 & ERC721 tokens

contract TokenManager is Ownable {
    address private ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    mapping(string => address) public contractAddressERC20;
    mapping(string => address) public contractAddressERC721;

    mapping(address => uint256) public balances;

    // Contract constructor
    constructor() public {
    }

    function depositETH() external payable {
        //TODO: save mapping with address & amount, to track how much every sender put
        require(msg.value > 0, "Amount must be greater than 0 ethers");
        //emit DepositEther(msg.sender, msg.value);  
    }

    function getBalance() public view returns (uint256) {
        return payable(address(this)).balance;
    }
}