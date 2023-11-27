import Foundation

open class Repository: Codable, Identifiable {
    // MARK: Lifecycle

    public init(
        id: Int = -1,
        owner: User = .init(),
        name: String? = nil,
        fullName: String? = nil,
        isPrivate: Bool = false,
        description: String? = nil,
        isFork: Bool = false,
        gitURL: String? = nil,
        sshURL: String? = nil,
        cloneURL: String? = nil,
        htmlURL: String? = nil,
        size: Int? = nil,
        lastPush: Date? = nil,
        stargazersCount: Int? = nil,
        watchersCount: Int? = nil
    ) {
        self.id = id
        self.owner = owner
        self.name = name
        self.fullName = fullName
        self.isPrivate = isPrivate
        self.description = description
        self.isFork = isFork
        self.gitURL = gitURL
        self.sshURL = sshURL
        self.cloneURL = cloneURL
        self.htmlURL = htmlURL
        self.size = size
        self.lastPush = lastPush
        self.stargazersCount = stargazersCount
        self.watchersCount = watchersCount
    }

    // MARK: Open

    open private(set) var id: Int
    open private(set) var owner: User
    open var name: String?
    open var fullName: String?
    open private(set) var isPrivate: Bool
    open var description: String?
    open private(set) var isFork: Bool
    open var gitURL: String?
    open var sshURL: String?
    open var cloneURL: String?
    open var htmlURL: String?
    open private(set) var size: Int?
    open var lastPush: Date?
    open var stargazersCount: Int?
    open var watchersCount: Int?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case description
        case isFork = "fork"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case htmlURL = "html_url"
        case size
        case lastPush = "pushed_at"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
    }
}

public extension Octokit {
    /// Fetches the Repositories for a user or organization
    /// - parameter owner: The user or organization that owns the repositories. If `nil`, fetches repositories for the authenticated user.
    /// - parameter page: Current page for repository pagination. `1` by default.
    /// - parameter perPage: Number of repositories per page. `100` by default.
    func repositories(
        owner: String? = nil,
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [Repository] {
        let path: String
        if let owner {
            path = "users/\(owner)/repos"
        } else {
            path = "user/repos"
        }

        let request = URLRequestBuilder(path: path)
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches a repository for a user or organization
    /// - parameter owner: The user or organization that owns the repositories.
    /// - parameter name: The name of the repository to fetch.
    func repository(
        owner: String,
        name: String
    ) async throws -> Repository {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(name)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
