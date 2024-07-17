import ballerina/cache;
import ballerina/http;
import ballerina/lang.array;

final cache:Cache cache = new ({
    defaultMaxAge: 6000,
    capacity: 100,
    evictionFactor: 0.2
});

const GENRES_KEY = "top_genres";
const LIRBARY_STATS_KEY = "library_stats";

@display {
    label: "Analytics Service",
    id: "da9b072e-e54c-4af0-865f-882ff507ccc0"
}
service / on new http:Listener(8081) {
    @display {
        label: "Book Service",
        id: "61e00f06-4051-4f30-b7ac-28db7bc28440"
    }
    http:Client booksClient;

    function init() returns error? {
        self.booksClient = check new ("http://localhost:8080");
    }

    // Get basic library statistics
    resource function get stats() returns Stats|error {
        var cachedStats = cache.get(LIRBARY_STATS_KEY);
        if cachedStats is Stats {
            return cachedStats;
        }

        json[] books = check self.booksClient->/books;
        json[] authors = check self.booksClient->/authors;
        json[] digitalCopies = check self.booksClient->/digitalcopies;

        Stats stats = {
            totalBooks: books.length(),
            totalAuthors: authors.length(),
            totalDigitalCopies: digitalCopies.length(),
            averageBooksPerAuthor: <float>books.length() / authors.length()
        };
        check cache.put(LIRBARY_STATS_KEY, stats);
        return stats;
    }

    // Get top 3 genres
    resource function get top\-genres() returns json[]|error {
        var cachedGenres = cache.get(GENRES_KEY);
        if cachedGenres is json[] {
            return cachedGenres;
        }

        json[] books = check self.booksClient->/books;
        var topGenres = from var book in books
            group by var genre = check book.genre
            let int count = array:length([book])
            order by count descending
            limit 3
            select {genre, count};

        check cache.put(GENRES_KEY, topGenres);
        return topGenres;
    }

    // Invalidate cache (admin endpoint)
    resource function post cache/invalidate() returns string|error {
        error? result = cache.invalidateAll();
        if result is error {
            return error("Failed to invalidate cache: " + result.message());
        }
        return "Cache invalidated successfully";
    }
}
