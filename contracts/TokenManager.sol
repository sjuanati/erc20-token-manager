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

    mapping(address => uint256) public balancesETH;
    mapping(address => uint256) public balancesERC20;
    mapping(address => uint256) public balancesERC721;

    // Contract constructor
    constructor() public {
    }

    function depositETH() external payable {
        require(msg.value > 0, "Amount must be greater than 0 ethers");
        balancesETH[msg.sender] += msg.value;
        //emit DepositEther(msg.sender, msg.value);  
    }
    
    function balanceOf(address _from) public view returns (uint256) {
        return balancesETH[_from];
    }


}