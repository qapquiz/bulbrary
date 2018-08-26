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
    mapping (uint => address) private booksReserveBy; // bookId => address
    mapping (uint => address) private bookSellBy; // bookId => address
    mapping (address => uint256) private stakes; // address => sum of stake
    mapping (uint => uint32) private booksCanCancelAfter; // bookId => timestamp
    mapping (uint => string) private booksTrackingNumbers; // bookId => trackingNumber

    constructor(address _bookERC721Address) public {
        bookERC721Instance = BookERC721(_bookERC721Address); 
    }

    modifier bookMustReserve(uint _bookId) {
        require(booksReserve[_bookId], "book must be reserve by someone.");
        _;
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
        booksReserveBy[bookId] = 0x0;
        bookSellBy[bookId] = msg.sender;
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
        booksReserveBy[_bookId] = msg.sender;
        booksCanCancelAfter[_bookId] = uint32(block.timestamp + (86400 * 4));
    }

    // seller call
    function stakeBook(uint _bookId, string _trackingNumber) public {
        // msg.sender call
        address seller = msg.sender;
        bookERC721Instance.transferFrom(seller, address(this), _bookId);
        addTrackingNumber(_bookId, _trackingNumber);
    }

    function getTrackingNumber(uint _bookId) public view returns (string) {
        return booksTrackingNumbers[_bookId];
    }

    function addTrackingNumber(uint _bookId, string _trackingNumber) private bookMustReserve(_bookId) {
        booksTrackingNumbers[_bookId] = _trackingNumber;
    }

    // buyer call
    function cancelBuyRequest(uint _bookId) public bookMustReserve(_bookId) {
        require(uint32(block.timestamp) >= booksCanCancelAfter[_bookId], "can cancel after 4 days of the date that you bought.");
        clearReserveBook(_bookId);
    }

    // seller
    function cancelOrder(uint _bookId) public bookMustReserve(_bookId) {
        address buyer = booksReserveBy[_bookId];
        (, , , , uint price) = bookERC721Instance.getBook(_bookId);
        stakes[buyer] -= price;

        clearReserveBook(_bookId);

        buyer.transfer(price);
    } 

    // owner approve automatic by server check after approximately 2 days
    function approveReceivedBook(uint _bookId) public onlyOwner {
        require(_bookId >= 0, "bookId is index of array so that mean must greater than 0");
        require(booksReserveBy[_bookId] != 0x0, "book must be reserved by someone.");

        address seller = bookSellBy[_bookId];
        address buyer = booksReserveBy[_bookId];
        (, , , , uint price) = bookERC721Instance.getBook(_bookId);

        subtractBuyerStake(buyer, price);
        clearReserveBook(_bookId);
        swapBookOwner(_bookId, buyer);

        // send token to buyer
        bookERC721Instance.transferFrom(address(this), buyer, _bookId);

        // send ether to seller
        seller.transfer(price);
    }

    function clearReserveBook(uint _bookId) private {
        booksReserve[_bookId] = false;
        booksReserveBy[_bookId] = 0x0;
    }

    function subtractBuyerStake(address _buyer, uint _bookPrice) private {
        require(stakes[_buyer] >= _bookPrice, "stake of buyer must be greter or equal _bookPrice");
        stakes[_buyer] -= _bookPrice;
    }

    function swapBookOwner(uint _bookId, address newOwner) public {
        bookSellBy[_bookId] = newOwner;
    }

    // Fallback function
    function() external payable {

    }
}
