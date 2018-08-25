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
    mapping (uint => bool) private booksReserve; // bookId => boolean // true => reserve
    mapping (address => uint256) private stakes; // address => sum of stake
    mapping (uint => uint32) private booksCanCancelAfter; // bookId => timestamp
    mapping (uint => string) private booksTrackingNumbers; // bookId => trackingNumber

    constructor(address _bookERC721Address) public {
        bookERC721Instance = BookERC721(_bookERC721Address); 
    }

    // book
    // registerBook => A token
    // seller => A token => buyer
    // buyer (A token book)

    function registerBook(
        string _title, 
        string _hashImage, 
        string _author, 
        string _publisher,
        uint _price
    ) 
        external
    {
        uint bookId = bookERC721Instance.mint(_title, _hashImage, _author, _publisher, _price);
        booksReserve[bookId] = false;
    }

    // buyer

    function buyBook(address _seller, uint _bookId) public payable {
        require(_seller != address(0), "You forget to send seller address to us.");
        require(_bookId >= 0, "bookId is index of array so that mean must greater than 0");
        require(bookERC721Instance.isOwnerOfTheBook(_seller, _bookId), "This book is not owned by this seller.");
        require(bookERC721Instance.getBookPrice(_bookId) == msg.value, "Your money not enough for buy this book.");
        require(!booksReserve[_bookId], "This book is already reserved by the other.");

        stakeCoin(_bookId, msg.value);
    }

    function stakeCoin(uint _bookId, uint256 buyerEth) private {
        stakes[msg.sender] += buyerEth;
        booksReserve[_bookId] = true;
        booksCanCancelAfter[_bookId] = uint32(block.timestamp + (86400 * 4));

    }

    // seller call
    function stakeBook(uint _bookId, string _trackingNumber) public {
        // msg.sender call
        address seller = msg.sender;
        bookERC721Instance.transferFrom(seller, address(this), _bookId);
        addTrackingNumber(_bookId, _trackingNumber);
    }

    // seller
    function addTrackingNumber(uint _bookId, string _trackingNumber) private {
        require(booksReserve[_bookId], "");

        booksTrackingNumbers[_bookId] = _trackingNumber;
    }

    // owner approve automatic by server check after approximately 2 days
    function approveReceivedBook(uint _bookId) public view onlyOwner {

    }

    // Fallback function
    function() external payable {

    }
}
