import ballerina/http;
import ballerina/jwt;
import ballerina/log;
import ballerina/time;

// Configuration for upstream services
configurable string bookServiceUrl = "http://localhost:8080";
configurable string analyticsServiceUrl = "http://localhost:8081";

// JWT configuration
configurable string issuer = "api_gateway";
configurable string audience = "api_users";
configurable string jwtSecret = "your_jwt_secret";

// Rate limiting configuration
configurable int requestLimit = 100;
configurable int windowSizeInSeconds = 60;

// In-memory store for rate limiting
map<int> requestCount = {};

@display {
    label: "Gateway Service",
    id: "a2659a60-3466-4f60-bdc7-b139d834da36"
}
service / on new http:Listener(9090) {
    @display {
        label: "Book Service",
        id: "61e00f06-4051-4f30-b7ac-28db7bc28440"
    }
    private final http:Client bookClient;

    @display {
        label: "Analytics Service",
        id: "da9b072e-e54c-4af0-865f-882ff507ccc0"
    }
    private final http:Client analyticsClient;

    function init() returns error? {
        self.bookClient = check new (bookServiceUrl);
        self.analyticsClient = check new (analyticsServiceUrl);
    }

    // Authentication interceptor
    resource function 'default [string... paths](http:Request req) returns http:Response|error {
        // Extract the JWT from the Authorization header
        string|error authHeader = req.getHeader("Authorization");
        if authHeader is error {
            return createErrorResponse(http:STATUS_UNAUTHORIZED, "Missing Authorization header");
        }

        string jwt = authHeader.startsWith("Bearer ") ? authHeader.substring(7) : authHeader;

        // Validate the JWT
        jwt:Payload|error payload = validateJwt(jwt);
        if payload is error {
            return createErrorResponse(http:STATUS_UNAUTHORIZED, "Invalid token");
        }

        // Check rate limit
        string? username = payload.sub;
        if username is string {
            if !checkRateLimit(username) {
                return createErrorResponse(http:STATUS_TOO_MANY_REQUESTS, "Rate limit exceeded");
            }
        }

        // Log the request
        log:printInfo(string `Received request: ${req.method} ${req.rawPath}`, userId = username);

        // Forward the request to the appropriate service
        var response = self.interpretPath(paths, req);
        if response is error {
            log:printError(string `Error processing request: ${response.message()}`, userId = username);
            return createErrorResponse(http:STATUS_INTERNAL_SERVER_ERROR, response.message());
        }

        return response;
    }

    // Helper function to route requests based on path
    function interpretPath(string[] paths, http:Request req) returns http:Response|error {
        if paths[0] == "books" || paths[0] == "authors" || paths[0] == "digitalcopies" {
        } else if paths[0] == "stats" || paths[0] == "top-genres" || paths[0] == "cache" {
            return self.analyticsClient->forward(req.rawPath, req);
        } else if paths[0] == "health" {
            return createJsonResponse({status: "UP", message: "API Gateway is running"});
        } else if paths[0] == "services" {
            return createJsonResponse({
                                          "book_service": bookServiceUrl,
                                          "analytics_service": analyticsServiceUrl
                                      });
        }
        return createErrorResponse(http:STATUS_NOT_FOUND, "Resource not found");
    }
}

// JWT validation function
function validateJwt(string token) returns jwt:Payload|error {
    jwt:ValidatorConfig config = {
        issuer: issuer,
        audience: audience
        // signatureConfig: {

        //     jwksConfig: {
        //         keys: [
        //             {
        //                 kty: "oct",
        //                 use: "sig",
        //                 kid: "1",
        //                 k: jwtSecret
        //             }
        //         ]
        //     }
        // }
    };

    return jwt:validate(token, config);
}

// Rate limiting function
function checkRateLimit(string username) returns boolean {
    int currentTime = time:utcNow()[0];
    int windowStart = currentTime - windowSizeInSeconds;

    // Clean up old entries
    foreach var [key, timestamp] in requestCount.entries() {
        if timestamp < windowStart {
            _ = requestCount.remove(key);
        }
    }

    // Check and update rate limit
    string key = string `${username}_${currentTime}`;
    int currentCount = requestCount.get(key);
    if currentCount >= requestLimit {
        return false;
    }
    requestCount[key] = currentCount + 1;
    return true;
}

// Helper function to create JSON responses
function createJsonResponse(json payload) returns http:Response {
    http:Response response = new;
    response.setJsonPayload(payload);
    return response;
}

// Helper function to create error responses
function createErrorResponse(int statusCode, string message) returns http:Response {
    http:Response response = new;
    response.statusCode = statusCode;
    response.setJsonPayload({'error: message});
    return response;
}
