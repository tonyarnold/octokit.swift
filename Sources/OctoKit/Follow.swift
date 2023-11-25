import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension Octokit {
    /**
         Fetches the followers of the authenticated user
     */
        func myFollowers() async throws -> [User] {
        let router = FollowRouter.readAuthenticatedFollowers(configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self)
    }

    /**
         Fetches the followers of a user
         - parameter name: Name of the user
     */
        func followers(name: String) async throws -> [User] {
        let router = FollowRouter.readFollowers(name, configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self)
    }

    /**
         Fetches the users following the authenticated user
     */
        func myFollowing() async throws -> [User] {
        let router = FollowRouter.readAuthenticatedFollowing(configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self)
    }

    /**
         Fetches the users following a user
         - parameter name: The name of the user
     */
        func following(name: String) async throws -> [User] {
        let router = FollowRouter.readFollowing(name, configuration)
        return try await router.load(session, dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: [User].self)
    }
}

enum FollowRouter: Router {
    case readAuthenticatedFollowers(Configuration)
    case readFollowers(String, Configuration)
    case readAuthenticatedFollowing(Configuration)
    case readFollowing(String, Configuration)

    var method: HTTPMethod {
        return .GET
    }

    var encoding: HTTPEncoding {
        return .url
    }

    var configuration: Configuration {
        switch self {
        case let .readAuthenticatedFollowers(config): return config
        case let .readFollowers(_, config): return config
        case let .readAuthenticatedFollowing(config): return config
        case let .readFollowing(_, config): return config
        }
    }

    var path: String {
        switch self {
        case .readAuthenticatedFollowers:
            return "user/followers"
        case let .readFollowers(username, _):
            return "users/\(username)/followers"
        case .readAuthenticatedFollowing:
            return "user/following"
        case let .readFollowing(username, _):
            return "users/\(username)/following"
        }
    }

    var params: [String: Any] {
        return [:]
    }
}
