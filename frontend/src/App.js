import React, { Component } from 'react';
// import logo from './logo.svg';
// import './App.css';
import Web3Helper from './config/web3';
import BookERC721 from './contracts/BookERC721.json';
import Web3 from 'web3';

import { Button } from 'semantic-ui-react'

class App extends Component {
  state = {
    contractAddress: '',
    BookERC721Contract: '',
  }

  async componentDidMount() {
    const web3 = await Web3Helper.getWeb3();
    const contractAddress = BookERC721.networks['42'].address;
    const accounts = await web3.eth.getAccounts();
    console.log('contractAddress', contractAddress);
    console.log('BookERC721', BookERC721);
    const BookERC721Contract = new web3.eth.Contract(BookERC721.abi, contractAddress);
    console.log('BookERC721Contract', BookERC721Contract);
    this.setState({
      contractAddress,
      BookERC721Contract,
      userAddress: accounts[0],
    })
  }

  mint = () => {
    console.log('mint');
    console.log('contractAddress', this.state.contractAddress);
    console.log('BookERC721Contract', this.state.BookERC721Contract);
    console.log('userAddress', this.state.userAddress);
    const BookERC721Contract = this.state.BookERC721Contract;
    BookERC721Contract.methods.mint('1234', '1234', '1234').send({
      from: this.state.userAddress,
    })
    .on('receipt', (receipt) => {
      console.log('receipt', receipt);
      
    })
    .on('error', (err) => {
      
    });
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          {/* <img src={logo} className="App-logo" alt="logo" /> */}
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <p className="App-intro">
          <Button onClick={this.mint}>OK</Button>
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
      </div>
    );
  }
}

export default App;
