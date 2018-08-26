const BookERC721 = artifacts.require("./BookERC721.sol");

module.exports = function(deployer) {
    deployer.deploy(BookERC721);
};
