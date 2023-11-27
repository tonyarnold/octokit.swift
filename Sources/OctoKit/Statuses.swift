import Foundation

open class Status: Codable, Identifiable {
    // MARK: Open

    open private(set) var id: Int = -1
    open var url: String?
    open var avatarURL: String?
    open var nodeID: String?
    open var state: State?
    open var description: String?
    open var targetURL: String?
    open var context: String?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var creator: User?

    // MARK: Public

    public enum State: String, Codable {
        case error
        case failure
        case pending
        case success
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case avatarURL = "avatar_url"
        case nodeID = "node_id"
        case state
        case description
        case targetURL = "target_url"
        case context
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case creator
    }
}

// MARK: - Request

public extension Octokit {
    /// Creates a commit status
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter sha: The commit SHA.
    /// - parameter state: The state of the status. Can be one of `.error`, `.failure`, `.pending`, or `.success`.
    /// - parameter targetURL: The target URL to associate with this status. This URL will be linked from the GitHub UI to allow users to easily see the source of the status.
    /// - parameter description: A short description of the status.
    /// - parameter context: A string label to differentiate this status from the status of other systems.
    func createCommitStatus(
        owner: String,
        repository: String,
        sha: String,
        state: Status.State,
        targetURL: String? = nil,
        description: String? = nil,
        context: String? = nil
    ) async throws -> Status {
        struct Body: Codable {
            var state: Status.State
            var targetURL: String?
            var description: String?
            var context: String?

            enum CodingKeys: String, CodingKey {
                case state
                case targetURL = "target_url"
                case description
                case context
            }
        }

        let body = Body(state: state, targetURL: targetURL, description: description, context: context)
        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/statuses/\(sha)")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches commit statuses for a reference
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter ref: SHA, a branch name, or a tag name.
    /// - parameter page: The page to request.
    /// - parameter perPage: The number of pulls to return on each page, max is 100.
    func listCommitStatuses(
        owner: String,
        repository: String,
        ref: String,
        page: Int? = nil,
        perPage: Int? = nil
    ) async throws -> [Status] {
        var request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/commits/\(ref)/statuses")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)

        if let page {
            request = request.queryItem(name: "page", value: "\(page)")
        }

        if let perPage {
            request = request.queryItem(name: "per_page", value: "\(perPage)")
        }

        return try await session.json(
            for: request.makeRequest(withBaseURL: configuration.apiEndpoint),
            decoder: decoder
        )
    }
}
