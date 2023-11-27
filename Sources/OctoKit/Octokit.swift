import Foundation

public struct Octokit {
    // MARK: Lifecycle

    public init(
        configuration: TokenConfiguration = TokenConfiguration(),
        session: URLSession = .shared,
        encoder: JSONEncoder = Self.defaultJSONEncoder,
        decoder: JSONDecoder = Self.defaultJSONDecoder
    ) {
        self.configuration = configuration
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }

    // MARK: Public

    public static let defaultJSONEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return encoder
    }()

    public static let defaultJSONDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return decoder
    }()

    public let configuration: TokenConfiguration
    public let session: URLSession
    public let encoder: JSONEncoder
    public let decoder: JSONDecoder
}
