import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import Web3Helper from './config/web3';
import Bulbrary from './contracts/Bulbrary.json';
import Web3 from 'web3';

class App extends Component {
  state = {
    
  }
  
  async componentDidMount() {
    const web3 = await Web3Helper.getWeb3();
    const contractAddress = Bulbrary.networks['42'].address;
    console.log('Bulbrary', Bulbrary);
    const BulbaryContract = new web3.eth.Contract(Bulbrary.abi, contractAddress);
    console.log('web3', web3);
    console.log('BulbaryContract', BulbaryContract);

  }
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </div>
    );
  }
}

export default App;
