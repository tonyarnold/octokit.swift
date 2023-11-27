import Foundation

public struct Release: Codable, Identifiable {
    public init(
        id: Int,
        url: URL,
        htmlURL: URL,
        assetsURL: URL,
        tarballURL: URL?,
        zipballURL: URL?,
        nodeID: String,
        tagName: String,
        commitish: String,
        name: String,
        body: String,
        draft: Bool,
        prerelease: Bool,
        createdAt: Date,
        publishedAt: Date?,
        author: User
    ) {
        self.id = id
        self.url = url
        self.htmlURL = htmlURL
        self.assetsURL = assetsURL
        self.tarballURL = tarballURL
        self.zipballURL = zipballURL
        self.nodeID = nodeID
        self.tagName = tagName
        self.commitish = commitish
        self.name = name
        self.body = body
        self.draft = draft
        self.prerelease = prerelease
        self.createdAt = createdAt
        self.publishedAt = publishedAt
        self.author = author
    }

    public let id: Int
    public let url: URL
    public let htmlURL: URL
    public let assetsURL: URL
    public let tarballURL: URL?
    public let zipballURL: URL?
    public let nodeID: String
    public let tagName: String
    public let commitish: String
    public let name: String
    public let body: String
    public let draft: Bool
    public let prerelease: Bool
    public let createdAt: Date
    public let publishedAt: Date?
    public let author: User

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case name
        case body
        case draft
        case prerelease
        case author

        case htmlURL = "html_url"
        case assetsURL = "assets_url"
        case tarballURL = "tarball_url"
        case zipballURL = "zipball_url"
        case nodeID = "node_id"
        case tagName = "tag_name"
        case commitish = "target_commitish"
        case createdAt = "created_at"
        case publishedAt = "published_at"
    }
}

// MARK: request

public extension Octokit {
    /// Fetches a published release with the specified tag.
    /// - Parameters:
    ///   - tag: The specified tag
    @discardableResult
    func release(
        owner: String,
        repository: String,
        tag: String
    ) async throws -> Release {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/releases/tags/\(tag)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches the list of releases.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repository: The name of the repository.
    ///   - perPage: Results per page (max 100). Default: `30`.2
    func listReleases(
        owner: String,
        repository: String,
        perPage: Int = 30
    ) async throws -> [Release] {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/releases")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .queryItem(name: "per_page", value: "\(perPage)")
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches the latest release.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repository: The name of the repository.
    func getLatestRelease(
        owner: String,
        repository: String
    ) async throws -> Release {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/releases/latest")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Creates a new release.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the release needs to be created.
    ///   - tagName: The name of the tag.
    ///   - targetCommitish: Specifies the commitish value that determines where the Git tag is created from. Can be any branch or commit SHA. Unused if the Git tag already exists. Default: the repository's default branch (usually master).
    ///   - name: The name of the release.
    ///   - body: Text describing the contents of the tag.
    ///   - prerelease: `true` to create a draft (unpublished) release, `false` to create a published one. Default: `false`.
    ///   - draft: `true` to identify the release as a prerelease. `false` to identify the release as a full release. Default: `false`.
    ///   - generateNotes: `true` to automatically generate release name and body. Default: `false`.
    func postRelease(
        owner: String,
        repository: String,
        tagName: String,
        targetCommitish: String? = nil,
        name: String? = nil,
        body: String? = nil,
        prerelease: Bool = false,
        draft: Bool = false,
        generateNotes: Bool = false
    ) async throws -> Release {
        struct Body: Codable {
            var tagName: String
            var targetCommitish: String?
            var name: String?
            var body: String?
            var prerelease: Bool
            var draft: Bool
            var generateNotes: Bool

            enum CodingKeys: String, CodingKey {
                case tagName = "tag_name"
                case targetCommitish = "target_commitish"
                case name
                case body
                case prerelease
                case draft
                case generateNotes = "generate_release_notes"
            }
        }

        let body = Body(
            tagName: tagName,
            targetCommitish: targetCommitish,
            name: name,
            body: body,
            prerelease: prerelease,
            draft: draft,
            generateNotes: generateNotes
        )

        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/releases")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Deletes a release.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the release needs to be deleted.
    ///   - releaseId: The ID of the release to delete.
    func deleteRelease(
        owner: String,
        repository: String,
        releaseID: Int
    ) async throws {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/releases/\(releaseID)")
            .method(.delete)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        try await session.sendRequest(for: request)
    }
}
