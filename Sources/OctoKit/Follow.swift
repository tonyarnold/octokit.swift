import Foundation

public extension Octokit {
    /// Fetches the followers of the authenticated user
    func myFollowers() async throws -> [User] {
        let request = URLRequestBuilder(path: "user/followers")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches the followers of a user
    /// - parameter name: Name of the user
    func followers(name: String) async throws -> [User] {
        let request = URLRequestBuilder(path: "users/\(name)/followers")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches the users following the authenticated user
    func myFollowing() async throws -> [User] {
        let request = URLRequestBuilder(path: "user/following")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches the users following a user
    /// - parameter name: The name of the user
    func following(name: String) async throws -> [User] {
        let request = URLRequestBuilder(path: "users/\(name)/following")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
