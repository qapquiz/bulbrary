import Web3 from 'web3';

const Web3Helper = (function () {
    let web3 = null;

    function setWeb3() {
        return new Promise((resolve, reject) => {
            window.addEventListener('load', function () {
                web3 = window.web3;
                if (typeof web3 !== 'undefined') {
                    // Use Mist/MetaMask's provider.
                    web3 = new Web3(web3.currentProvider);
                    console.log('Injected web3 detected.');              
                    resolve(web3);
                } else {
                    console.log('No web3 instance injected');
                    web3 = null;
                    resolve(web3);
                }
            });
        });
    }

    return { 
        // public interface
        getWeb3: async function () {
            if (!web3) {
                await setWeb3();
            }
            return web3;
        }
    };
})();

export default Web3Helper;
