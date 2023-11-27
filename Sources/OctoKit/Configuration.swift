import Foundation

public let githubBaseURL = URL(string: "https://api.github.com")!
public let githubWebURL = URL(string: "https://github.com")!

public protocol Configuration {
    var apiEndpoint: URL { get }
    var accessToken: String? { get }
    var accessTokenFieldName: String { get }
    var authorizationHeader: String? { get }
    var customHeaders: [HTTPHeaderField]? { get }
}

public extension Configuration {
    var accessTokenFieldName: String { "access_token" }

    var authorizationHeader: String? { nil }

    var customHeaders: [HTTPHeaderField]? { nil }

    var authorizationHeaderValue: String? {
        guard let authorizationHeader, let accessToken else {
            return nil
        }

        return "\(authorizationHeader) \(accessToken)"
    }
}

public struct TokenConfiguration: Configuration {
    // MARK: Lifecycle

    public init(_ token: String? = nil, url: URL = githubBaseURL) {
        accessToken = token?.data(using: .utf8)!.base64EncodedString()
        apiEndpoint = url
    }

    public init(bearerToken: String, url: URL = githubBaseURL) {
        apiEndpoint = url
        authorizationHeader = "Bearer"
        accessToken = bearerToken
    }

    // MARK: Public

    public var apiEndpoint: URL
    public var accessToken: String?
    public private(set) var authorizationHeader: String? = "Basic"
}

public struct OAuthConfiguration: Configuration {
    // MARK: Lifecycle

    public init(
        _ url: URL = githubBaseURL,
        webURL: URL = githubWebURL,
        token: String,
        secret: String,
        scopes: [String],
        session: URLSession = .shared
    ) {
        apiEndpoint = url
        webEndpoint = webURL
        self.token = token
        self.secret = secret
        self.scopes = scopes
        self.session = session
    }

    // MARK: Public

    public var apiEndpoint: URL
    public var accessToken: String?
    public let token: String
    public let secret: String
    public let scopes: [String]
    public let webEndpoint: URL

    public func authenticate() -> URL? {
        let request = URLRequestBuilder(path: "login/oauth/authorize")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "scope", value: scopes.joined(separator: ","))
            .queryItem(name: "client_id", value: token)
            .queryItem(name: "allow_signup", value: "false")
            .makeRequest(withBaseURL: apiEndpoint)

        return request.url
    }

    public func authorize(code: String) async throws -> TokenConfiguration? {
        let request = URLRequestBuilder(path: "login/oauth/authorize")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "client_id", value: token)
            .queryItem(name: "client_secret", value: secret)
            .queryItem(name: "code", value: code)
            .makeRequest(withBaseURL: apiEndpoint)

        let (data, response) = try await session.data(for: request, delegate: nil)

        guard
            let response = response as? HTTPURLResponse, response.statusCode == 200,
            let string = String(data: data, encoding: .utf8),
            let accessToken = accessTokenFromResponse(string)
        else {
            return nil
        }

        return TokenConfiguration(accessToken, url: apiEndpoint)
    }

    public func handleOpenURL(url: URL) async throws -> TokenConfiguration? {
        guard let code = url.queryParameters["code"] else {
            return nil
        }

        return try await authorize(code: code)
    }

    public func accessTokenFromResponse(_ response: String) -> String? {
        let accessTokenParam = response.components(separatedBy: "&").first
        if let accessTokenParam = accessTokenParam {
            return accessTokenParam.components(separatedBy: "=").last
        }
        return nil
    }

    // MARK: Private

    private let session: URLSession
}

public struct HTTPHeaderField: Codable {
    var name: String
    var value: String?
}
