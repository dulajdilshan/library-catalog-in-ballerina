import ballerina/persist as _;
import ballerinax/persist.sql;

type Book record {|
    @sql:Generated
    readonly int id;
    string title;
    string isbn;
    int year;
    string genre;
    Author author;
    DigitalCopy? digitalcopy;
|};

type Author record {|
    @sql:Generated
    readonly int id;
    string name;
    Book[] book;
|};

type DigitalCopy record {|
    @sql:Generated
    readonly int id;
    Book book;
    string fileUrl;
    string format;
|};
