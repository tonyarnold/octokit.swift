import Foundation

public enum HTTP {
    public enum Method: String, CaseIterable, Identifiable {
        case connect
        case delete
        case get
        case head
        case options
        case patch
        case post
        case put
        case trace

        /// The unique HTTP method identifier.
        public var id: String { rawValue }

        /// The uppercased HTTP method name.
        public var method: String { id.uppercased() }
    }
}

public extension URLRequest {
    var method: HTTP.Method? {
        guard let httpMethod else {
            return nil
        }

        return HTTP.Method(rawValue: httpMethod.lowercased())
    }
}
