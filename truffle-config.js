/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    kovan: {
      provider: function () {
        return new HDWalletProvider(
          "kitchen board decrease material film plug gold agree shaft feature feed coffee",
          "https://kovan.infura.io/v3/1100994c16a34b70aae27b9818c3e205")
      },
      network_id: '42',
      gas: 4500000,
      gasPrice: 10000000000,
    },
  }
};
