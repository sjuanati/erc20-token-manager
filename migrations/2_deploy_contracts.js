const TokenManager = artifacts.require("TokenManager");

module.exports = (deployer, network, accounts) => {
	// if (accounts) {
	// 	// Create contract with 1 ether (contract must be payable)
	// 	deployer.deploy(TokenManager, network, { from: accounts[0], value: "1000000000000000000" });
	// };
	deployer.deploy(TokenManager, network);
};
