import Foundation

open class User: Codable, Identifiable {
    // MARK: Lifecycle

    public init(
        id: Int = -1,
        login: String? = nil,
        avatarURL: String? = nil,
        gravatarID: String? = nil,
        type: String? = nil,
        name: String? = nil,
        company: String? = nil,
        blog: String? = nil,
        location: String? = nil,
        email: String? = nil,
        numberOfPublicRepos: Int? = nil,
        numberOfPublicGists: Int? = nil,
        numberOfPrivateRepos: Int? = nil,
        nodeID: String? = nil,
        url: String? = nil,
        htmlURL: String? = nil,
        followersURL: String? = nil,
        followingURL: String? = nil,
        gistsURL: String? = nil,
        starredURL: String? = nil,
        subscriptionsURL: String? = nil,
        reposURL: String? = nil,
        eventsURL: String? = nil,
        receivedEventsURL: String? = nil,
        siteAdmin: Bool? = nil,
        hireable: Bool? = nil, bio: String? = nil,
        twitterUsername: String? = nil,
        numberOfFollowers: Int? = nil,
        numberOfFollowing: Int? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        numberOfPrivateGists: Int? = nil,
        numberOfOwnPrivateRepos: Int? = nil,
        amountDiskUsage: Int? = nil,
        numberOfCollaborators: Int? = nil,
        twoFactorAuthenticationEnabled: Bool? = nil,
        subscriptionPlan: Plan? = nil
    ) {
        self.id = id
        self.login = login
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.type = type
        self.name = name
        self.company = company
        self.blog = blog
        self.location = location
        self.email = email
        self.numberOfPublicRepos = numberOfPublicRepos
        self.numberOfPublicGists = numberOfPublicGists
        self.numberOfPrivateRepos = numberOfPrivateRepos
        self.nodeID = nodeID
        self.url = url
        self.htmlURL = htmlURL
        self.followersURL = followersURL
        self.followingURL = followingURL
        self.gistsURL = gistsURL
        self.starredURL = starredURL
        self.subscriptionsURL = subscriptionsURL
        self.reposURL = reposURL
        self.eventsURL = eventsURL
        self.receivedEventsURL = receivedEventsURL
        self.siteAdmin = siteAdmin
        self.hireable = hireable
        self.bio = bio
        self.twitterUsername = twitterUsername
        self.numberOfFollowers = numberOfFollowers
        self.numberOfFollowing = numberOfFollowing
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.numberOfPrivateGists = numberOfPrivateGists
        self.numberOfOwnPrivateRepos = numberOfOwnPrivateRepos
        self.amountDiskUsage = amountDiskUsage
        self.numberOfCollaborators = numberOfCollaborators
        self.twoFactorAuthenticationEnabled = twoFactorAuthenticationEnabled
        self.subscriptionPlan = subscriptionPlan
    }

    // MARK: Open

    open internal(set) var id: Int
    open var login: String?
    open var avatarURL: String?
    open var gravatarID: String?
    open var type: String?
    open var name: String?
    open var company: String?
    open var blog: String?
    open var location: String?
    open var email: String?
    open var numberOfPublicRepos: Int?
    open var numberOfPublicGists: Int?
    open var numberOfPrivateRepos: Int?
    open var nodeID: String?
    open var url: String?
    open var htmlURL: String?
    open var followersURL: String?
    open var followingURL: String?
    open var gistsURL: String?
    open var starredURL: String?
    open var subscriptionsURL: String?
    open var reposURL: String?
    open var eventsURL: String?
    open var receivedEventsURL: String?
    open var siteAdmin: Bool?
    open var hireable: Bool?
    open var bio: String?
    open var twitterUsername: String?
    open var numberOfFollowers: Int?
    open var numberOfFollowing: Int?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var numberOfPrivateGists: Int?
    open var numberOfOwnPrivateRepos: Int?
    open var amountDiskUsage: Int?
    open var numberOfCollaborators: Int?
    open var twoFactorAuthenticationEnabled: Bool?
    open var subscriptionPlan: Plan?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case type
        case name
        case company
        case blog
        case location
        case email
        case numberOfPublicRepos = "public_repos"
        case numberOfPublicGists = "public_gists"
        case numberOfPrivateRepos = "total_private_repos"
        case nodeID = "node_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case siteAdmin = "site_admin"
        case hireable
        case bio
        case twitterUsername = "twitter_username"
        case numberOfFollowers = "followers"
        case numberOfFollowing = "following"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case numberOfPrivateGists = "private_gists"
        case numberOfOwnPrivateRepos = "owned_private_repos"
        case amountDiskUsage = "disk_usage"
        case numberOfCollaborators = "collaborators"
        case twoFactorAuthenticationEnabled = "two_factor_authentication"
        case subscriptionPlan = "plan"
    }
}

// MARK: request

public extension Octokit {
    /// Fetches a user or organization
    /// - parameter name: The name of the user or organization.
    func user(name: String) async throws -> User {
        let request = URLRequestBuilder(path: "users/\(name)")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }

    /// Fetches the authenticated user
    func me() async throws -> User {
        let request = URLRequestBuilder(path: "user")
            .method(.get)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
