// AUTO-GENERATED FILE. DO NOT MODIFY.

// This file is an auto-generated file by Ballerina persistence layer for model.
// It should not be modified by hand.

public type Book record {|
    readonly int id;
    string title;
    string isbn;
    int year;
    string genre;
    int authorId;

|};

public type BookOptionalized record {|
    int id?;
    string title?;
    string isbn?;
    int year?;
    string genre?;
    int authorId?;
|};

public type BookWithRelations record {|
    *BookOptionalized;
    AuthorOptionalized author?;
    DigitalCopyOptionalized digitalcopy?;
|};

public type BookTargetType typedesc<BookWithRelations>;

public type BookInsert Book;

public type BookUpdate record {|
    string title?;
    string isbn?;
    int year?;
    string genre?;
    int authorId?;
|};

public type Author record {|
    readonly int id;
    string name;

|};

public type AuthorOptionalized record {|
    int id?;
    string name?;
|};

public type AuthorWithRelations record {|
    *AuthorOptionalized;
    BookOptionalized[] book?;
|};

public type AuthorTargetType typedesc<AuthorWithRelations>;

public type AuthorInsert Author;

public type AuthorUpdate record {|
    string name?;
|};

public type DigitalCopy record {|
    readonly int id;
    int bookId;
    string fileUrl;
    string format;
|};

public type DigitalCopyOptionalized record {|
    int id?;
    int bookId?;
    string fileUrl?;
    string format?;
|};

public type DigitalCopyWithRelations record {|
    *DigitalCopyOptionalized;
    BookOptionalized book?;
|};

public type DigitalCopyTargetType typedesc<DigitalCopyWithRelations>;

public type DigitalCopyInsert DigitalCopy;

public type DigitalCopyUpdate record {|
    int bookId?;
    string fileUrl?;
    string format?;
|};

