import Foundation

public struct Review: Codable, Identifiable {
    // MARK: Public

    public let body: String
    public let commitID: String
    public let id: Int
    public let state: State
    public let submittedAt: Date
    public let user: User

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case body
        case commitID = "commit_id"
        case id
        case state
        case submittedAt = "submitted_at"
        case user
    }
}

public extension Review {
    enum State: String, Codable, Equatable {
        case approved = "APPROVED"
        case changesRequested = "CHANGES_REQUESTED"
        case comment = "COMMENTED"
        case dismissed = "DISMISSED"
        case pending = "PENDING"
    }
}

public extension Review {
    enum Event: String, Codable {
        case approve = "APPROVE"
        case requestChanges = "REQUEST_CHANGES"
        case comment = "COMMENT"
        case pending = "PENDING"
    }

    struct Comment: Codable {
        enum CodingKeys: String, CodingKey {
            case path
            case position
            case body
            case line
            case side
            case startLine = "start_line"
            case startSide = "start_side"
        }

        var path: String
        var position: Int?
        var body: String
        var line: Int?
        var side: String?
        var startLine: Int?
        var startSide: String?
    }
}

public extension Octokit {
    func listReviews(
        owner: String,
        repository: String,
        pullRequestNumber: Int
    ) async throws -> [Review] {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/pulls/\(pullRequestNumber)/reviews")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    @discardableResult
    func postReview(
        owner: String,
        repository: String,
        pullRequestNumber: Int,
        commitID: String? = nil,
        event: Review.Event,
        body: String? = nil,
        comments: [Review.Comment] = []
    ) async throws -> Review {
        struct Body: Codable {
            var commitID: String?
            var event: Review.Event
            var body: String?
            var comments: [Review.Comment]

            enum CodingKeys: String, CodingKey {
                case commitID = "commit_id"
                case event
                case body
                case comments
            }
        }

        let body = Body(
            commitID: commitID,
            event: event,
            body: body,
            comments: comments
        )
        let request = try URLRequestBuilder(path: "repos/\(owner)/\(repository)/pulls/\(pullRequestNumber)/reviews")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
