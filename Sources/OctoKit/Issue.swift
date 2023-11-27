import Foundation

open class Issue: Codable, Identifiable {
    // MARK: Open

    open private(set) var id: Int
    open var url: URL?
    open var repositoryURL: URL?
    open var commentsURL: URL?
    open var eventsURL: URL?
    open var htmlURL: URL?
    open var number: Int
    open var state: State?
    open var title: String?
    open var body: String?
    open var user: User?
    open var labels: [Label]?
    open var assignee: User?
    open var milestone: Milestone?
    open var locked: Bool?
    open var comments: Int?
    open var closedAt: Date?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var closedBy: User?

    // MARK: Public

    public enum State: String, Codable {
        case open
        case closed
        case all
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case repositoryURL = "repository_url"
        case commentsURL = "comments_url"
        case eventsURL = "events_url"
        case htmlURL = "html_url"
        case number
        case state
        case title
        case body
        case user
        case labels
        case assignee
        case milestone
        case locked
        case comments
        case closedAt = "closed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedBy = "closed_by"
    }
}

public struct Comment: Codable, Identifiable {
    // MARK: Public

    public let id: Int
    public let url: URL
    public let htmlURL: URL
    public let body: String
    public let user: User
    public let createdAt: Date
    public let updatedAt: Date
    public let reactions: Reactions?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case body
        case user
        case reactions
        case htmlURL = "html_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: request

public extension Octokit {
    /// Fetches the issues of the authenticated user
    /// - parameter state: Issue state. Defaults to open if not specified.
    /// - parameter page: Current page for issue pagination. `1` by default.
    /// - parameter perPage: Number of issues per page. `100` by default.
    func myIssues(
        state: Issue.State = .open,
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [Issue] {
        struct Body: Codable {
            var state: Issue.State
            var page: Int
            var perPage: Int

            enum CodingKeys: String, CodingKey {
                case state
                case page
                case perPage = "per_page"
            }
        }

        let body = Body(
            state: state,
            page: page,
            perPage: perPage
        )

        let request = try URLRequestBuilder(path: "issues")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches an issue in a repository
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter number: The number of the issue.
    func issue(owner: String, repository: String, number: Int) async throws -> Issue {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/issues/\(number)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches all issues in a repository
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter state: Issue state. Defaults to open if not specified.
    /// - parameter page: Current page for issue pagination. `1` by default.
    /// - parameter perPage: Number of issues per page. `100` by default.
    func issues(
        owner: String,
        repository: String,
        state: Issue.State = .open,
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [Issue] {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/issues")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "state", value: "\(state.rawValue)")
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Creates an issue in a repository.
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter title: The title of the issue.
    /// - parameter body: The body text of the issue in GitHub-flavored Markdown format.
    /// - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
    /// - parameter labels: An array of label names to add to the issue. If the labels do not exist, GitHub will create them automatically. This parameter is ignored if the user lacks push access to the repository.
    func postIssue(
        owner: String,
        repository: String,
        title: String,
        body: String? = nil,
        assignee: String? = nil,
        labels: [String] = []
    ) async throws -> Issue {
        struct Body: Codable {
            var title: String
            var body: String?
            var assignee: String?
            var labels: [String]
        }

        let body = Body(
            title: title,
            body: body,
            assignee: assignee,
            labels: labels
        )

        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/issues")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Edits an issue in a repository.
    /// - parameter owner: The user or organization that owns the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter number: The number of the issue.
    /// - parameter title: The title of the issue.
    /// - parameter body: The body text of the issue in GitHub-flavored Markdown format.
    /// - parameter assignee: The name of the user to assign the issue to. This parameter is ignored if the user lacks push access to the repository.
    /// - parameter state: Whether the issue is open or closed.
    func patchIssue(
        owner: String,
        repository: String,
        number: Int,
        title: String? = nil,
        body: String? = nil,
        assignee: String? = nil,
        state: Issue.State? = nil
    ) async throws -> Issue {
        struct Body: Codable {
            var title: String?
            var body: String?
            var assignee: String?
            var state: Issue.State?
        }

        let body = Body(
            title: title,
            body: body,
            assignee: assignee,
            state: state
        )

        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/issues/\(number)")
            .method(.patch)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Posts a comment on an issue using the given body.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the issue.
    ///   - body: The contents of the comment.
    func commentIssue(
        owner: String,
        repository: String,
        number: Int,
        body: String
    ) async throws -> Comment {
        struct Body: Codable {
            var body: String
        }

        let body = Body(
            body: body
        )

        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/issues/\(number)/comments")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches all comments for an issue
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the issue.
    ///   - page: Current page for comments pagination. `1` by default.
    ///   - perPage: Number of comments per page. `100` by default.
    func issueComments(
        owner: String,
        repository: String,
        number: Int,
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [Comment] {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/issues/\(number)/comments")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Edits a comment on an issue using the given body.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repository.
    ///   - repository: The name of the repository.
    ///   - number: The number of the comment.
    ///   - body: The contents of the comment.
    func patchIssueComment(
        owner: String,
        repository: String,
        number: Int,
        body: String
    ) async throws -> Comment {
        struct Body: Codable {
            var body: String
        }

        let body = Body(
            body: body
        )

        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/issues/comments/\(number)")
            .method(.patch)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
