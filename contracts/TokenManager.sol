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

    mapping(string => address) public contractERC20;
    mapping(string => address) public contractERC721;

    mapping(address => uint256) public balancesETH;
    mapping(address => uint256) public balancesERC20;
    mapping(address => uint256) public balancesERC721;

    event DepositEther(address indexed from, uint256 amount);
    event WithdrawEther(address indexed to, uint256 amount);

    // Contract constructor
    constructor(string memory network) public {
        // Register DAI & UNI contract addresses
        if (compareStrings(network, "ganachina")) {
            registerERC20("DAI", 0xaD6D458402F60fD3Bd25163575031ACDce07538D);
            registerERC20("UNI", 0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
        }
    }

    function compareStrings(string memory s1, string memory s2) private pure returns(bool){
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }

    function registerERC20(string memory _tokenName, address _tokenContract) public onlyOwner {
        require(bytes(_tokenName).length != 0,
            "Token name can't be empty");
        require(contractERC20[_tokenName] == ZERO_ADDRESS,
            "ERC20 contract address already registered");
        require(bytes(_tokenName).length < 30,
            "Token name length too long (should be <30 characters)");
        contractERC20[_tokenName] = _tokenContract;
    }

    function unregisterERC20(string memory _tokenName) public onlyOwner {
        require(contractERC20[_tokenName] != ZERO_ADDRESS,
            "ERC20 contract address already registered");
        contractERC20[_tokenName] = ZERO_ADDRESS;
    }

    /**
     * @notice  Transfer ether from sender address to contract address
     * @dev     - Amount to be deposited must be greater than 0 ethers 
     */
    function depositETH() external payable {
        require(msg.value > 0, "Amount must be greater than 0 ethers");
        balancesETH[msg.sender] = balancesETH[msg.sender].add(msg.value);
        emit DepositEther(msg.sender, msg.value);
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
        emit WithdrawEther(msg.sender, amount);
    }
    
    function balanceOf(address _from) public view returns (uint256) {
        return balancesETH[_from];
    }

}