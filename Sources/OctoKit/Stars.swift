import Foundation

public extension Octokit {
    /// Fetches all the starred repositories for a user
    /// - parameter name: The user who starred repositories.
    func stars(name: String) async throws -> [Repository] {
        let request = URLRequestBuilder(path: "users/\(name)/starred")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches all the starred repositories for the authenticated user
    /// - Returns: The repos which the authenticated user stars.
    func myStars() async throws -> [Repository] {
        let request = URLRequestBuilder(path: "users/starred")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Checks if a repository is starred by the authenticated user
    /// - parameter owner: The name of the owner of the repository.
    /// - parameter repository: The name of the repository.
    /// - Returns: If the repository is starred by the authenticated user
    func star(
        owner: String,
        repository: String
    ) async throws -> Bool {
        let request = URLRequestBuilder(path: "user/starred/\(owner)/\(repository)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        do {
            try await session.sendRequest(for: request)
            return true
        } catch let error as APIRequestRouterError {
            switch error {
                case let .unsuccessfulRequest(statusCode, _) where statusCode == 404:
                    return false

                default:
                    throw error
            }
        } catch {
            throw error
        }
    }

    /// Stars a repository for the authenticated user
    /// - parameter owner: The name of the owner of the repository.
    /// - parameter repository: The name of the repository.
    func putStar(
        owner: String,
        repository: String
    ) async throws {
        let request = URLRequestBuilder(path: "user/starred/\(owner)/\(repository)")
            .method(.put)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        try await session.sendRequest(for: request)
    }

    /// Unstars a repository for the authenticated user
    /// - parameter owner: The name of the owner of the repository.
    /// - parameter repository: The name of the repository.
    func deleteStar(
        owner: String,
        repository: String
    ) async throws {
        let request = URLRequestBuilder(path: "user/starred/\(owner)/\(repository)")
            .method(.delete)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        try await session.sendRequest(for: request)
    }
}
