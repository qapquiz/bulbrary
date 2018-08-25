const Bulbrary = artifacts.require("./Bulbrary.sol");
const BookERC721 = artifacts.require("./BookERC721.sol");

module.exports = function(deployer) {
    deployer.deploy(Bulbrary);
    deployer.deploy(BookERC721, "BBToken", "BBT");
};
