import ballerina/http;

// Initialize the persist client
final Client persistClient = check new ();

@display {
    label: "Book Service",
    id: "61e00f06-4051-4f30-b7ac-28db7bc28440"
}
service / on new http:Listener(8080) {

    // Get all books
    resource function get books() returns Book[]|error {
        stream<Book, error?> bookStream = persistClient->/books();
        return from Book book in bookStream
            select book;
    }

    // Get a specific book by ID
    resource function get books/[int id]() returns Book|error {
        return persistClient->/books/[id]();
    }

    // Add a new book
    resource function post books(@http:Payload BookInsert book) returns int|error {
        int[]|error result = persistClient->/books.post([book]);
        if result is int[] {
            return result[0];
        }
        return result;
    }

    // Update a book
    resource function put books/[int id](@http:Payload BookUpdate book) returns Book|error {
        return persistClient->/books/[id].put(book);
    }

    // Delete a book
    resource function delete books/[int id]() returns Book|error {
        return persistClient->/books/[id].delete();
    }

    // Get all authors
    resource function get authors() returns Author[]|error {
        stream<Author, error?> authorStream = persistClient->/authors();
        return from Author author in authorStream
            select author;
    }

    // Get a specific author by ID
    resource function get authors/[int id]() returns Author|error {
        return persistClient->/authors/[id]();
    }

    // Add a new author
    resource function post authors(@http:Payload AuthorInsert author) returns int|error {
        int[]|error result = persistClient->/authors.post([author]);
        if result is int[] {
            return result[0];
        }
        return result;
    }

    // Get all digital copies
    resource function get digitalcopies() returns DigitalCopy[]|error {
        stream<DigitalCopy, error?> digitalCopyStream = persistClient->/digitalcopies();
        return from DigitalCopy copy in digitalCopyStream
            select copy;
    }

    // Get a specific digital copy by ISD
    resource function get digitalcopies/[int isd]() returns DigitalCopy|error {
        return persistClient->/digitalcopies/[isd]();
    }

    // Add a new digital copy
    resource function post digitalcopies(@http:Payload DigitalCopyInsert copy) returns int|error {
        int[]|error result = persistClient->/digitalcopies.post([copy]);
        if result is int[] {
            return result[0];
        }
        return result;
    }

    // Search books by title (partial match)
    resource function get books/search/[string title]() returns Book[]|error {
        stream<Book, error?> bookStream = persistClient->/books();
        return from Book book in bookStream
            where book.title.toLowerAscii().includes(title.toLowerAscii())
            select book;
    }

    // Get books by author ID
    resource function get authors/[int id]/books() returns Book[]|error {
        stream<Book, error?> bookStream = persistClient->/books();
        return from Book book in bookStream
            where book.authorId == id
            select book;
    }
}
