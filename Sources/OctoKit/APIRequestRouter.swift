import Foundation

public enum APIRequestRouterError: Swift.Error {
    case missingURLRequest
    case unsuccessfulRequest(statusCode: Int, underlyingError: ErrorContents)

    // MARK: Public

    public enum ErrorContents {
        case string(String)
        case dictionary([String: Any])
        case empty
    }
}

public extension HTTPURLResponse {
    var wasSuccessful: Bool {
        let successRange = 200 ..< 300
        return successRange.contains(statusCode)
    }
}
