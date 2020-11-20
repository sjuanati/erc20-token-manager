// SPDX-License-Identifier: MIT
pragma solidity ^0.6.5;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol";

// https://ethereum.stackexchange.com/questions/10864/erc20-token-and-effective-way-to-store-dividends

/// @author SJS
/// @title Manages ERC20 & ERC721 tokens

contract TokenManager is Ownable {
    using SafeMath for uint256;
    address private ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    mapping(string => address) public contractAddressERC20;
    mapping(string => address) public contractAddressERC721;

    mapping(address => uint256) public balancesETH;
    mapping(address => uint256) public balancesERC20;
    mapping(address => uint256) public balancesERC721;

    // Contract constructor
    constructor() public {
    }

    /**
     * @notice  Transfer ether from sender address to contract address
     * @dev     - Amount to be deposited must be greater than 0 ethers 
     */
    function depositETH() external payable {
        require(msg.value > 0, "Amount must be greater than 0 ethers");
        balancesETH[msg.sender] = balancesETH[msg.sender].add(msg.value);
    }

    /**
     * @notice  Transfer ether from contract address to sender address
     *          - Contract must have enough balance to do the transfer
     * @param   amount Amount of ether to be transferred
     */
    function withdrawETH(uint256 amount) public {
        require(payable(address(this)).balance >= amount, 
            "Insufficient funds in contract");
        require(balancesETH[msg.sender] >= amount,
            "Insufficient balance from user in contract");
        balancesETH[msg.sender] = balancesETH[msg.sender].sub(amount);
        address payable recipient = msg.sender;
        recipient.transfer(amount);
    }
    
    function balanceOf(address _from) public view returns (uint256) {
        return balancesETH[_from];
    }

}