import Foundation

open class PullRequest: Codable, Identifiable {
    public init(
        id: Int = -1,
        url: URL? = nil,
        htmlURL: URL? = nil,
        diffURL: URL? = nil,
        patchURL: URL? = nil,
        issueURL: URL? = nil,
        commitsURL: URL? = nil,
        reviewCommentsURL: URL? = nil,
        reviewCommentURL: URL? = nil,
        commentsURL: URL? = nil,
        statusesURL: URL? = nil,
        title: String? = nil,
        body: String? = nil,
        assignee: User? = nil,
        milestone: Milestone? = nil,
        locked: Bool? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        closedAt: Date? = nil,
        mergedAt: Date? = nil,
        user: User? = nil,
        number: Int,
        state: State? = nil,
        labels: [Label]? = nil,
        head: PullRequest.Branch? = nil,
        base: PullRequest.Branch? = nil,
        requestedReviewers: [User]? = nil,
        draft: Bool? = nil
    ) {
        self.id = id
        self.url = url
        self.htmlURL = htmlURL
        self.diffURL = diffURL
        self.patchURL = patchURL
        self.issueURL = issueURL
        self.commitsURL = commitsURL
        self.reviewCommentsURL = reviewCommentsURL
        self.reviewCommentURL = reviewCommentURL
        self.commentsURL = commentsURL
        self.statusesURL = statusesURL
        self.title = title
        self.body = body
        self.assignee = assignee
        self.milestone = milestone
        self.locked = locked
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.closedAt = closedAt
        self.mergedAt = mergedAt
        self.user = user
        self.number = number
        self.state = state
        self.labels = labels
        self.head = head
        self.base = base
        self.requestedReviewers = requestedReviewers
        self.draft = draft
    }

    open class Branch: Codable {
        open var label: String?
        open var ref: String?
        open var sha: String?
        open var user: User?
        open var repo: Repository?
    }

    open private(set) var id: Int
    open var url: URL?

    open var htmlURL: URL?
    open var diffURL: URL?
    open var patchURL: URL?
    open var issueURL: URL?
    open var commitsURL: URL?
    open var reviewCommentsURL: URL?
    open var reviewCommentURL: URL?
    open var commentsURL: URL?
    open var statusesURL: URL?

    open var title: String?
    open var body: String?

    open var assignee: User?
    open var milestone: Milestone?

    open var locked: Bool?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var closedAt: Date?
    open var mergedAt: Date?

    open var user: User?
    open var number: Int
    open var state: State?
    open var labels: [Label]?

    open var head: PullRequest.Branch?
    open var base: PullRequest.Branch?

    open var requestedReviewers: [User]?
    open var draft: Bool?

    public enum State: String, Codable {
        case open
        case closed
        case all
    }

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case diffURL = "diff_url"
        case patchURL = "patch_url"
        case issueURL = "issue_url"
        case commitsURL = "commits_url"
        case reviewCommentsURL = "review_comments_url"
        case commentsURL = "comments_url"
        case statusesURL = "statuses_url"
        case htmlURL = "html_url"
        case number
        case state
        case title
        case body
        case assignee
        case milestone
        case locked
        case user
        case labels
        case closedAt = "closed_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mergedAt = "merged_at"
        case head
        case base
        case requestedReviewers = "requested_reviewers"
        case draft
    }
}

public extension PullRequest {
    struct File: Codable {
        public var sha: String
        public var filename: String
        public var status: Status
        public var additions: Int
        public var deletions: Int
        public var changes: Int
        public var blobURL: String
        public var rawURL: String
        public var contentsURL: String
        public var patch: String
    }
}

public extension PullRequest.File {
    enum Status: String, Codable {
        case added
        case removed
        case modified
        case renamed
        case copied
        case changed
        case unchanged
    }
}

extension PullRequest.File {
    enum CodingKeys: String, CodingKey {
        case sha
        case filename
        case status
        case additions
        case deletions
        case changes
        case blobURL = "blob_url"
        case rawURL = "raw_url"
        case contentsURL = "contents_url"
        case patch
    }
}

// MARK: Request

public extension Octokit {
    /// Create a pull request
    /// - parameter owner: The user or organization that owns the repositories.
    /// - parameter repository: The name of the repository.
    /// - parameter title: The title of the new pull request.
    /// - parameter head: The name of the branch where your changes are implemented.
    /// - parameter headRepo: The name of the repository where the changes in the pull request were made.
    /// - parameter base: The name of the branch you want the changes pulled into.
    /// - parameter body: The contents of the pull request.
    /// - parameter maintainerCanModify: Indicates whether maintainers can modify the pull request.
    /// - parameter draft: Indicates whether the pull request is a draft.
    /// - Returns: A PullRequest
    func createPullRequest(
        owner: String,
        repository: String,
        title: String,
        head: String,
        headRepo: String? = nil,
        base: String,
        body: String? = nil,
        maintainerCanModify: Bool? = nil,
        draft: Bool? = nil
    ) async throws -> PullRequest {
        struct Body: Codable {
            var title: String
            var head: String
            var headRepo: String?
            var base: String
            var body: String?
            var maintainerCanModify: Bool?
            var draft: Bool?

            enum CodingKeys: String, CodingKey {
                case title
                case head
                case headRepo = "head_repo"
                case base
                case body
                case maintainerCanModify = "maintainer_can_modify"
                case draft
            }
        }

        let body = Body(
            title: title,
            head: head,
            headRepo: headRepo,
            base: base,
            body: body,
            maintainerCanModify: maintainerCanModify,
            draft: draft
        )
        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/pulls")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Get a single pull request
    /// - parameter owner: The user or organization that owns the repositories.
    /// - parameter repository: The name of the repository.
    /// - parameter number: The number of the PR to fetch.
    func pullRequest(
        owner: String,
        repository: String,
        number: Int
    ) async throws -> PullRequest {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/pulls/\(number)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Get a list of pull requests
    /// - parameter owner: The user or organization that owns the repositories.
    /// - parameter repository: The name of the repository.
    /// - parameter base: Filter pulls by base branch name.
    /// - parameter head: Filter pulls by user or organization and branch name.
    /// - parameter state: Filter pulls by their state.
    /// - parameter direction: The direction of the sort.
    func pullRequests(
        owner: String,
        repository: String,
        base: String? = nil,
        head: String? = nil,
        state: PullRequest.State = .open,
        sort: SortType = .created,
        page: Int? = nil,
        perPage: Int? = nil,
        direction: SortDirection = .descending
    ) async throws -> [PullRequest] {
        var request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/pulls")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .queryItem(name: "state", value: state.rawValue)
            .queryItem(name: "sort", value: sort.rawValue)
            .queryItem(name: "direction", value: direction.rawValue)

        if let base {
            request = request.queryItem(name: "base", value: base)
        }

        if let head {
            request = request.queryItem(name: "head", value: head)
        }

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

    /// Updates a pull request
    /// - parameter owner: The user or organization that owns the repositories.
    /// - parameter repository: The name of the repository.
    /// - parameter number: The number of the PR to update.
    /// - parameter title: The new tite of the PR
    /// - parameter body: The new body of the PR
    /// - parameter state: The new state of the PR
    /// - parameter base: The new baseBranch of the PR
    /// - parameter mantainerCanModify: The new baseBranch of the PR
    func patchPullRequest(
        owner: String,
        repository: String,
        number: Int,
        title: String,
        body: String,
        state: PullRequest.State,
        base: String?,
        mantainerCanModify: Bool?
    ) async throws -> PullRequest {
        guard state != .all else {
            fatalError("PullRequest.State.all is not supported as a setting")
        }

        struct Body: Codable {
            var title: String
            var base: String?
            var body: String
            var maintainerCanModify: Bool?

            enum CodingKeys: String, CodingKey {
                case title
                case base
                case body
                case maintainerCanModify = "maintainer_can_modify"
            }
        }

        let body = Body(
            title: title,
            base: base,
            body: body,
            maintainerCanModify: mantainerCanModify
        )

        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/pulls/\(number)")
            .method(.patch)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    func listPullRequestsFiles(
        owner: String,
        repository: String,
        number: Int,
        perPage: Int? = nil,
        page: Int? = nil
    ) async throws -> [PullRequest.File] {
        var request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/pulls/\(number)/files")
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
