import Foundation
import RequestKit
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// MARK: request

public extension Octokit {
        func postPublicKey(publicKey: String, title: String) async throws -> String {
        let router = PublicKeyRouter.postPublicKey(publicKey, title, configuration)
        _ = try await router.postJSON(session, expectedResultType: [String: AnyObject].self)
        return publicKey
    }
}

enum PublicKeyRouter: JSONPostRouter {
    case postPublicKey(String, String, Configuration)

    var configuration: Configuration {
        switch self {
        case let .postPublicKey(_, _, config): return config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postPublicKey:
            return .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .postPublicKey:
            return .json
        }
    }

    var path: String {
        switch self {
        case .postPublicKey:
            return "user/keys"
        }
    }

    var params: [String: Any] {
        switch self {
        case let .postPublicKey(publicKey, title, _):
            return ["title": title, "key": publicKey]
        }
    }
}
