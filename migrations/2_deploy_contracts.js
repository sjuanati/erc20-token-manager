const TokenManager = artifacts.require("TokenManager");

module.exports = function(deployer) {
  deployer.deploy(TokenManager);
};

