pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./BookERC721.sol";

contract Bulbrary is Ownable {

    struct Book {
        string title;
        string hashImage;
        string author;
        string publisher;
        uint price;
    }

    BookERC721 private bookERC721Instance;

    constructor(address _bookERC721Address) public {
        bookERC721Instance = BookERC721(_bookERC721Address); 
    }

    function registerBook(
        string _title, 
        string _hashImage, 
        string _author, 
        string _publisher,
        uint _price
    ) 
        external
    {
        bookERC721Instance.mint(_title, _hashImage, _author, _publisher, _price);
    }

    function buyBook(address _seller, uint _bookId) public payable {
        require(_seller != address(0), "You forget to send seller address to us.");
        require(_bookId >= 0, "bookId is index of array so that mean must greater than 0");
        require(bookERC721Instance.isOwnerOfTheBook(_seller, _bookId), "This book is not owned by this seller.");
        require(bookERC721Instance.getBookPrice(_bookId) <= msg.value, "Your money not enough for buy this book.");

        // stakeCoin(msg.value);
        // stakeBook(_bookId);
    }

    // Fallback function
    function() external payable {

    }
}
