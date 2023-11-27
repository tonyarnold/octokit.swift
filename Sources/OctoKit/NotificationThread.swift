import Foundation

open class NotificationThread: Codable, Identifiable {
    // MARK: Open

    open internal(set) var id: String? = "-1"
    open var unread: Bool?
    open var reason: Reason?
    open var updatedAt: Date?
    open var lastReadAt: Date?
    open private(set) var subject = Subject()
    open private(set) var repository = Repository()

    // MARK: Public

    public class Subject: Codable, Identifiable {
        // MARK: Open

        open internal(set) var id: Int = -1
        open var title: String?
        open var url: String?
        open var latestCommentURL: String?
        open var type: String?

        // MARK: Internal

        enum CodingKeys: String, CodingKey {
            case title
            case url
            case latestCommentURL = "latest_comment_url"
            case type
        }
    }

    public enum Reason: String, Codable {
        case assign
        case author
        case comment
        case invitation
        case manual
        case mention
        case reviewRequested = "review_requested"
        case securityAlert = "security_alert"
        case stateChange = "state_change"
        case subscribed
        case teamMention = "team_mention"
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case unread
        case reason
        case updatedAt = "updated_at"
        case lastReadAt = "last_read_at"
        case subject
        case repository
    }
}

open class ThreadSubscription: Codable, Identifiable {
    // MARK: Open

    open internal(set) var id: Int? = -1
    open var subscribed: Bool?
    open var ignored: Bool?
    open var reason: String?
    open var url: String?
    open var threadURL: String?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case subscribed
        case ignored
        case reason
        case url
        case threadURL = "thread_url"
    }
}

// MARK: - Request

public extension Octokit {
    /// List all notifications for the current user, sorted by most recently updated.
    /// - parameter all: show notifications marked as read `false` by default.
    /// - parameter participating: only shows notifications in which the user is directly participating or mentioned. `false` by default.
    /// - parameter page: Current page for notification pagination. `1` by default.
    /// - parameter perPage: Number of notifications per page. `100` by default.
    @discardableResult
    func myNotifications(
        all: Bool = false,
        participating: Bool = false,
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [NotificationThread] {
        let request = URLRequestBuilder(path: "notifications")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "all", value: "\(all)")
            .queryItem(name: "participating", value: "\(participating)")
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Marks All Notifications As read
    /// - parameter lastReadAt: Describes the last point that notifications were checked `last_read_at` by default.
    /// - parameter read: Whether the notification has been read `false` by default.
    func markNotificationsRead(
        lastReadAt: String = "last_read_at",
        read: Bool = false
    ) async throws {
        let request = URLRequestBuilder(path: "notifications")
            .method(.put)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "last_read_at", value: "\(lastReadAt)")
            .queryItem(name: "read", value: "\(read)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        try await session.sendRequest(for: request)
    }

    /// Marks All Notifications As read
    /// - parameter threadID: The ID of the Thread.
    @discardableResult
    func getNotificationThread(threadID: String) async throws -> NotificationThread {
        let request = URLRequestBuilder(path: "notifications/threads/\(threadID)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Get a thread subscription for the authenticated user
    /// - parameter threadID: The ID of the Thread.
    ///
    @discardableResult
    func getThreadSubscription(threadID: String) async throws -> ThreadSubscription {
        let request = URLRequestBuilder(path: "notifications/threads/\(threadID)/subscription")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Sets a thread subscription for the authenticated user
    /// - parameter threadID: The ID of the Thread.
    /// - parameter ignored: Whether to block all notifications from a thread `false` by default.
    @discardableResult
    func setThreadSubscription(
        threadID: String,
        ignored: Bool = false
    ) async throws -> ThreadSubscription {
        let request = URLRequestBuilder(path: "notifications/threads/\(threadID)/subscription")
            .method(.put)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "ignored", value: "\(ignored)")
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Delete a thread subscription
    /// - parameter threadID: The ID of the Thread.
    func deleteThreadSubscription(threadID: String) async throws {
        let request = URLRequestBuilder(path: "notifications/threads/\(threadID)/subscription")
            .method(.delete)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        try await session.sendRequest(for: request)
    }

    /// List all repository notifications for the current user, sorted by most recently updated.
    /// - parameter owner: The name of the owner of the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter all: show notifications marked as read `false` by default.
    /// - parameter participating: only shows notifications in which the user is directly participating or mentioned. `false` by default.
    /// - parameter since: Only show notifications updated after the given time.
    /// - parameter before: Only show notifications updated before the given time.
    /// - parameter page: Current page for notification pagination. `1` by default.
    /// - parameter perPage: Number of notifications per page. `100` by default.
    @discardableResult
    func listRepositoryNotifications(
        owner: String,
        repository: String,
        all: Bool = false,
        participating: Bool = false,
        since: String? = nil,
        before: String? = nil,
        page: Int = 1,
        perPage: Int = 100
    ) async throws -> [NotificationThread] {
        var request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/notifications")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .queryItem(name: "all", value: "\(all)")
            .queryItem(name: "participating", value: "\(participating)")
            .queryItem(name: "page", value: "\(page)")
            .queryItem(name: "per_page", value: "\(perPage)")
            .configureAuthorization(using: configuration)

        if let since {
            request = request.queryItem(name: "since", value: since)
        }

        if let before {
            request = request.queryItem(name: "before", value: before)
        }

        return try await session.json(
            for: request.makeRequest(withBaseURL: configuration.apiEndpoint),
            decoder: decoder
        )
    }

    /// Marks All Repository Notifications As read
    /// - parameter owner: The name of the owner of the repository.
    /// - parameter repository: The name of the repository.
    /// - parameter lastReadAt: Describes the last point that notifications were checked `last_read_at` by default.
    func markRepositoryNotificationsRead(
        owner: String,
        repository: String,
        lastReadAt: String? = nil
    ) async throws {
        var request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/notifications")
            .method(.put)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)

        if let lastReadAt {
            request = request.queryItem(name: "last_read_at", value: lastReadAt)
        }

        try await session.sendRequest(for: request.makeRequest(withBaseURL: configuration.apiEndpoint))
    }
}
