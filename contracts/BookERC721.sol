pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract BookERC721 is ERC721Token {
    string public constant name = "BBToken";
    string public constant symbol = "BBT";

    struct Book {
        string title;
        string hashImage;
        string author;
    }

    Book[] public books;

    function getBook(uint _bookId) public view returns (string, string, string) {
        Book memory book = books[_bookId];
        return (book.title, book.hashImage, book.author);
    }

    function mint(string _title, string _hashImage, string _author) public {
        Book memory book = Book(_title, _hashImage, _author);
        uint bookId = books.push(book) - 1;

        _mint(msg.sender, bookId);
    }
}