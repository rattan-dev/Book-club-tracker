// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BookClubTracker {
    // Book structure
    struct Book {
        string title;          // Title of the book
        string author;         // Author of the book
        string review;         // Review for the book
        address owner;         // Address of the user who added the book
        uint256 timestamp;     // Timestamp of when the book was added
    }

    // Array to store books
    Book[] public books;

    // Events
    event BookAdded(uint256 bookId, string title, string author, address owner);
    event ReviewUpdated(uint256 bookId, string newReview);

    // Modifier to check book ownership
    modifier onlyOwner(uint256 _bookId) {
        require(msg.sender == books[_bookId].owner, "Not the book owner");
        _;
    }

    // Function to add a new book with a review
    function addBook(string memory _title, string memory _author, string memory _review) public {
        books.push(Book({
            title: _title,
            author: _author,
            review: _review,
            owner: msg.sender,
            timestamp: block.timestamp
        }));

        uint256 bookId = books.length - 1;
        emit BookAdded(bookId, _title, _author, msg.sender);
    }

    // Function to update the review of a book (only the owner can update)
    function updateReview(uint256 _bookId, string memory _newReview) public onlyOwner(_bookId) {
        require(_bookId < books.length, "Book does not exist");
        books[_bookId].review = _newReview;

        emit ReviewUpdated(_bookId, _newReview);
    }

    // Function to retrieve details of a specific book by ID
    function getBook(uint256 _bookId) public view returns (string memory, string memory, string memory, address, uint256) {
        require(_bookId < books.length, "Book does not exist");
        Book memory book = books[_bookId];
        return (book.title, book.author, book.review, book.owner, book.timestamp);
    }

    // Function to get the total number of books added
    function getTotalBooks() public view returns (uint256) {
        return books.length;
    }
}
