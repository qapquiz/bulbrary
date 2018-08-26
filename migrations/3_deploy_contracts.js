const Bulbrary = artifacts.require("./Bulbrary.sol");
const BookERC721 = artifacts.require("./BookERC721.sol");

const bookERC721Address = BookERC721.networks['42'].address;
module.exports = function(deployer) {
    deployer.deploy(Bulbrary, bookERC721Address);
};
