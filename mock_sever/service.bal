import ballerina/crypto;
import ballerina/http;

service / on new http:Listener(8080) {

    # Generate an ISBN number based on the book details.
    #
    # + payload - payload The book details
    # + return - The generated ISBN number
    resource function post isbn(@http:Payload IsbnRequest payload) returns IsbnResponse {
        string inputString = payload.title + payload.author + payload.year.toString();
        byte[] hash = crypto:hashSha256(inputString.toBytes());

        // Convert the first 13 bytes of the hash to a decimal string
        string hashStr = hash.slice(0, 13).toBase16();

        // Take the first 13 digits of the hash string
        string isbn = hashStr.substring(0, 13);

        return {isbn};
    }
}

type IsbnRequest record {
    string title;
    string author;
    int year;
};

type IsbnResponse record {
    string isbn;
};
