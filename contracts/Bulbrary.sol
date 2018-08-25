pragma solidity 0.4.24;

contract Bulbrary {
    uint public balance;

    constructor() public {
        balance = 1000;
    }

    function getBalance() public view returns(uint){
        return balance;
    }

    // Fallback function
    function() external payable {
        
    }
}
