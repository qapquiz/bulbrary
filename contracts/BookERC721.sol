pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract BookERC721 is ERC721Token {
    constructor() ERC721Token("BBToken", "BBT") public {}

    struct Book {
        string title;
        string hashImage;
        string author;
        string publisher;
        uint price;
    }

    Book[] public books;

    function getBookPrice(uint _bookId) external view returns (uint) {
        require(books.length >= _bookId, "_bookId cannot greter than books.length array.");

        (, , , , uint price) = this.getBook(_bookId);
        return price;
    }

    function isOwnerOfTheBook(address _userAddress, uint _bookId) external view returns (bool) {
        require(_userAddress != address(0), "you forget to send seller address to us.");
        require(_bookId >= 0, "bookId is index of array so that mean must greater than 0");

        return _userAddress != this.ownerOf(_bookId);
    }

    function getBook(uint _bookId) external view returns (string, string, string, string, uint) {
        Book memory book = books[_bookId];
        return (book.title, book.hashImage, book.author, book.publisher, book.price);
    }

    function mint(address _address, string _title, string _hashImage, string _author, string _publisher, uint _price) public returns (uint) {
        Book memory book = Book(_title, _hashImage, _author, _publisher, _price);
        uint bookId = books.push(book) - 1;

        _mint(_address, bookId);

        return bookId;
    }
}
