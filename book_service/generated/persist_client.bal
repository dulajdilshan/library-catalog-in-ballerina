// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

import ballerina/jballerina.java;
import ballerina/persist;
import ballerinax/persist.inmemory;

const BOOK = "books";
const AUTHOR = "authors";
const DIGITAL_COPY = "digitalcopies";
final isolated table<Book> key(id) booksTable = table [];
final isolated table<Author> key(id) authorsTable = table [];
final isolated table<DigitalCopy> key(id) digitalcopiesTable = table [];

public isolated client class Client {
    *persist:AbstractPersistClient;

    private final map<inmemory:InMemoryClient> persistClients;

    public isolated function init() returns persist:Error? {
        final map<inmemory:TableMetadata> metadata = {
            [BOOK]: {
                keyFields: ["id"],
                query: queryBooks,
                queryOne: queryOneBooks
            },
            [AUTHOR]: {
                keyFields: ["id"],
                query: queryAuthors,
                queryOne: queryOneAuthors,
                associationsMethods: {"book": queryAuthorBook}
            },
            [DIGITAL_COPY]: {
                keyFields: ["id"],
                query: queryDigitalcopies,
                queryOne: queryOneDigitalcopies
            }
        };
        self.persistClients = {
            [BOOK]: check new (metadata.get(BOOK).cloneReadOnly()),
            [AUTHOR]: check new (metadata.get(AUTHOR).cloneReadOnly()),
            [DIGITAL_COPY]: check new (metadata.get(DIGITAL_COPY).cloneReadOnly())
        };
    }

    isolated resource function get books(BookTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get books/[int id](BookTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post books(BookInsert[] data) returns int[]|persist:Error {
        int[] keys = [];
        foreach BookInsert value in data {
            lock {
                if booksTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("Book", value.id);
                }
                booksTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put books/[int id](BookUpdate value) returns Book|persist:Error {
        lock {
            if !booksTable.hasKey(id) {
                return persist:getNotFoundError("Book", id);
            }
            Book book = booksTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                book[k] = v;
            }
            booksTable.put(book);
            return book.clone();
        }
    }

    isolated resource function delete books/[int id]() returns Book|persist:Error {
        lock {
            if !booksTable.hasKey(id) {
                return persist:getNotFoundError("Book", id);
            }
            return booksTable.remove(id).clone();
        }
    }

    isolated resource function get authors(AuthorTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get authors/[int id](AuthorTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post authors(AuthorInsert[] data) returns int[]|persist:Error {
        int[] keys = [];
        foreach AuthorInsert value in data {
            lock {
                if authorsTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("Author", value.id);
                }
                authorsTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put authors/[int id](AuthorUpdate value) returns Author|persist:Error {
        lock {
            if !authorsTable.hasKey(id) {
                return persist:getNotFoundError("Author", id);
            }
            Author author = authorsTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                author[k] = v;
            }
            authorsTable.put(author);
            return author.clone();
        }
    }

    isolated resource function delete authors/[int id]() returns Author|persist:Error {
        lock {
            if !authorsTable.hasKey(id) {
                return persist:getNotFoundError("Author", id);
            }
            return authorsTable.remove(id).clone();
        }
    }

    isolated resource function get digitalcopies(DigitalCopyTargetType targetType = <>) returns stream<targetType, persist:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "query"
    } external;

    isolated resource function get digitalcopies/[int id](DigitalCopyTargetType targetType = <>) returns targetType|persist:Error = @java:Method {
        'class: "io.ballerina.stdlib.persist.inmemory.datastore.InMemoryProcessor",
        name: "queryOne"
    } external;

    isolated resource function post digitalcopies(DigitalCopyInsert[] data) returns int[]|persist:Error {
        int[] keys = [];
        foreach DigitalCopyInsert value in data {
            lock {
                if digitalcopiesTable.hasKey(value.id) {
                    return persist:getAlreadyExistsError("DigitalCopy", value.id);
                }
                digitalcopiesTable.put(value.clone());
            }
            keys.push(value.id);
        }
        return keys;
    }

    isolated resource function put digitalcopies/[int id](DigitalCopyUpdate value) returns DigitalCopy|persist:Error {
        lock {
            if !digitalcopiesTable.hasKey(id) {
                return persist:getNotFoundError("DigitalCopy", id);
            }
            DigitalCopy digitalcopy = digitalcopiesTable.get(id);
            foreach var [k, v] in value.clone().entries() {
                digitalcopy[k] = v;
            }
            digitalcopiesTable.put(digitalcopy);
            return digitalcopy.clone();
        }
    }

    isolated resource function delete digitalcopies/[int id]() returns DigitalCopy|persist:Error {
        lock {
            if !digitalcopiesTable.hasKey(id) {
                return persist:getNotFoundError("DigitalCopy", id);
            }
            return digitalcopiesTable.remove(id).clone();
        }
    }

    public isolated function close() returns persist:Error? {
        return ();
    }
}

isolated function queryBooks(string[] fields) returns stream<record {}, persist:Error?> {
    table<Book> key(id) booksClonedTable;
    lock {
        booksClonedTable = booksTable.clone();
    }
    table<Author> key(id) authorsClonedTable;
    lock {
        authorsClonedTable = authorsTable.clone();
    }
    return from record {} 'object in booksClonedTable
        outer join var author in authorsClonedTable on ['object.authorId] equals [author?.id]
        select persist:filterRecord({
                                        ...'object,
                                        "author": author
                                    }, fields);
}

isolated function queryOneBooks(anydata key) returns record {}|persist:NotFoundError {
    table<Book> key(id) booksClonedTable;
    lock {
        booksClonedTable = booksTable.clone();
    }
    table<Author> key(id) authorsClonedTable;
    lock {
        authorsClonedTable = authorsTable.clone();
    }
    from record {} 'object in booksClonedTable
    where persist:getKey('object, ["id"]) == key
    outer join var author in authorsClonedTable on ['object.authorId] equals [author?.id]
    do {
        return {
            ...'object,
            "author": author
        };
    };
    return persist:getNotFoundError("Book", key);
}

isolated function queryAuthors(string[] fields) returns stream<record {}, persist:Error?> {
    table<Author> key(id) authorsClonedTable;
    lock {
        authorsClonedTable = authorsTable.clone();
    }
    return from record {} 'object in authorsClonedTable
        select persist:filterRecord({
                                        ...'object
                                    }, fields);
}

isolated function queryOneAuthors(anydata key) returns record {}|persist:NotFoundError {
    table<Author> key(id) authorsClonedTable;
    lock {
        authorsClonedTable = authorsTable.clone();
    }
    from record {} 'object in authorsClonedTable
    where persist:getKey('object, ["id"]) == key
    do {
        return {
            ...'object
        };
    };
    return persist:getNotFoundError("Author", key);
}

isolated function queryDigitalcopies(string[] fields) returns stream<record {}, persist:Error?> {
    table<DigitalCopy> key(id) digitalcopiesClonedTable;
    lock {
        digitalcopiesClonedTable = digitalcopiesTable.clone();
    }
    table<Book> key(id) booksClonedTable;
    lock {
        booksClonedTable = booksTable.clone();
    }
    return from record {} 'object in digitalcopiesClonedTable
        outer join var book in booksClonedTable on ['object.bookId] equals [book?.id]
        select persist:filterRecord({
                                        ...'object,
                                        "book": book
                                    }, fields);
}

isolated function queryOneDigitalcopies(anydata key) returns record {}|persist:NotFoundError {
    table<DigitalCopy> key(id) digitalcopiesClonedTable;
    lock {
        digitalcopiesClonedTable = digitalcopiesTable.clone();
    }
    table<Book> key(id) booksClonedTable;
    lock {
        booksClonedTable = booksTable.clone();
    }
    from record {} 'object in digitalcopiesClonedTable
    where persist:getKey('object, ["id"]) == key
    outer join var book in booksClonedTable on ['object.bookId] equals [book?.id]
    do {
        return {
            ...'object,
            "book": book
        };
    };
    return persist:getNotFoundError("DigitalCopy", key);
}

isolated function queryAuthorBook(record {} value, string[] fields) returns record {}[] {
    table<Book> key(id) booksClonedTable;
    lock {
        booksClonedTable = booksTable.clone();
    }
    return from record {} 'object in booksClonedTable
        where 'object.authorId == value["id"]
        select persist:filterRecord({
                                        ...'object
                                    }, fields);
}

