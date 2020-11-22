// SPDX-License-Identifier: MIT
pragma solidity ^0.6.5;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/math/SafeMath.sol';
// import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol';
// import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol';
// import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol';
// import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol';

// https://ethereum.stackexchange.com/questions/10864/erc20-token-and-effective-way-to-store-dividends

/// @author SJS
/// @title Manages ERC20 & ERC721 tokens

contract TokenManager is Ownable {
    using SafeMath for uint256;
    address private ZERO_ADDRESS = 0x0000000000000000000000000000000000000000;

    mapping(bytes32 => address) public contractERC20;
    mapping(bytes32 => address) public contractERC721;

    mapping(address => uint256) public balancesETH;
    mapping(address => uint256) public balancesERC20;
    mapping(address => uint256) public balancesERC721;

    event DepositEther(address indexed from, uint256 amount);
    event WithdrawEther(address indexed to, uint256 amount);

    // Contract constructor    
    constructor () public {
    }

    /**
     * @notice  Register a list of contract addresses of ERC20 tokens
     *          - Token can't be already registered 
     */
    function bulkRegisterERC20(
        bytes32[] memory tokenNames,
        address[] memory tokenAddresses
    ) public onlyOwner {
        uint256 length = tokenNames.length;
        require(length == tokenAddresses.length,
            "Length mismatch: token array <> address array");
        for (uint256 i = 0; i < length; i++) {
            require(contractERC20[tokenNames[i]] == ZERO_ADDRESS,
                "ERC20 contract address already registered");
            contractERC20[tokenNames[i]] = tokenAddresses[i];
        }
    }

    /**
     * @notice  Register contract address of an ERC20 token
     *          - Token can't be already registered 
     */
    function registerERC20(bytes32 _tokenName, address _tokenContract) public onlyOwner {
        require(_tokenName[0] != 0,
            "Token name can't be empty");
        require(contractERC20[_tokenName] == ZERO_ADDRESS,
            "ERC20 contract address already registered");
        contractERC20[_tokenName] = _tokenContract;
    }

    /**
     * @notice  Unrgister contract address of an ERC20 token
     *          - Token must be already registered 
     */
    function unregisterERC20(bytes32 _tokenName) public onlyOwner {
        require(_tokenName[0] != 0,
            "Token name can't be empty");
        require(contractERC20[_tokenName] != ZERO_ADDRESS,
            "ERC20 contract not registered");
        contractERC20[_tokenName] = ZERO_ADDRESS;
    }

    /**
     * @notice  Transfer ether from sender address to contract address
     *          - Amount to be deposited must be greater than 0 ethers 
     */
    function depositETH() external payable {
        require(msg.value > 0, "Amount must be greater than 0 ethers");
        balancesETH[msg.sender] = balancesETH[msg.sender].add(msg.value);
        emit DepositEther(msg.sender, msg.value);
    }

    /**
     * @notice  Transfer ether from contract address to sender address
     *          - Contract must have enough balance to do the transfer
     *          - Msg.sender must withdraw an amount > 0 ethers
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
    
    /**
     * @notice  Returns the balance of msg.sender
     */
    function balanceOf(address _from) public view returns (uint256) {
        return balancesETH[_from];
    }

}