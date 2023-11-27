import Foundation

// MARK: model

open class Gist: Codable, Identifiable {
    // MARK: Open

    open private(set) var id: String?
    open var url: URL?
    open var forksURL: URL?
    open var commitsURL: URL?
    open var gitPushURL: URL?
    open var gitPullURL: URL?
    open var commentsURL: URL?
    open var htmlURL: URL?
    open var files: Files
    open var publicGist: Bool?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var description: String?
    open var comments: Int?
    open var user: User?
    open var owner: User?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case forksURL = "forks_url"
        case commitsURL = "commits_url"
        case gitPushURL = "git_pull_url"
        case gitPullURL = "git_push_url"
        case commentsURL = "comments_url"
        case htmlURL = "html_url"
        case files
        case publicGist = "public"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description
        case comments
        case user
        case owner
    }
}

// MARK: request

public extension Octokit {
    /// Fetches the gists of the authenticated user
    /// - parameter page: Current page for gist pagination. `1` by default.
    /// - parameter perPage: Number of gists per page. `100` by default.
    func myGists(
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [Gist] {
        let request = URLRequestBuilder(path: "gists")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches the gists of the specified user
    /// - parameter owner: The username who owns the gists.
    /// - parameter page: Current page for gist pagination. `1` by default.
    /// - parameter perPage: Number of gists per page. `100` by default.
    func gists(
        owner: String,
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [Gist] {
        let request = URLRequestBuilder(path: "users/\(owner)/gists")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches an gist
    /// - parameter id: The id of the gist.
    func gist(id: String) async throws -> Gist {
        let request = URLRequestBuilder(path: "gists/\(id)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Creates an gist with a single file.
    /// - parameter description: The description of the gist.
    /// - parameter filename: The name of the file in the gist.
    /// - parameter fileContent: The content of the file in the gist.
    /// - parameter isPublic: The public/private visability of the gist.
    func postGistFile(
        description: String,
        filename: String,
        fileContent: String,
        isPublic: Bool
    ) async throws -> Gist {
        struct Body: Codable {
            var description: String
            var files: [String: [String: String]]
            var isPublic: Bool

            enum CodingKeys: String, CodingKey {
                case description
                case files
                case isPublic = "public"
            }
        }

        let body = Body(
            description: description,
            files: [filename: ["content": fileContent]],
            isPublic: isPublic
        )

        let request = try URLRequestBuilder(path: "gists")
            .method(.post)
            .contentType(.applicationJSON)
            .accept(.applicationJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Edits an gist with a single file.
    /// - parameter id: The of the gist to update.
    /// - parameter description: The description of the gist.
    /// - parameter filename: The name of the file in the gist.
    /// - parameter fileContent: The content of the file in the gist.
    func patchGistFile(
        id: String,
        description: String,
        filename: String,
        fileContent: String
    ) async throws -> Gist {
        struct Body: Codable {
            var description: String
            var files: [String: [String: String]]

            enum CodingKeys: String, CodingKey {
                case description
                case files
            }
        }

        let body = Body(
            description: description,
            files: [filename: ["content": fileContent]]
        )

        let request = try URLRequestBuilder(path: "gists/\(id)")
            .method(.post)
            .contentType(.applicationJSON)
            .accept(.applicationJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
