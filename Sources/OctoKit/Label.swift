import Foundation

open class Label: Codable {
    open var url: URL?
    open var name: String?
    open var color: String?
}

public extension Octokit {
    /// Fetches a single label in a repository
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter name: The name of the label.
    func label(owner: String, repository: String, name: String) async throws -> Label {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/labels/\(name)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches all labels in a repository
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter page: Current page for label pagination. `1` by default.
    /// - parameter perPage: Number of labels per page. `100` by default.
    func labels(owner: String, repository: String, page: String = "1", perPage: String = "100") async throws -> [Label] {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/labels")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Create a label in a repository
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter name: The name of the label.
    /// - parameter color: The color of the label, in hexadecimal without the leading `#`.
    func postLabel(owner: String, repository: String, name: String, color: String) async throws -> Label {
        struct Body: Codable {
            var name: String
            var color: String
        }

        let body = Body(
            name: name,
            color: color
        )

        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/labels")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
