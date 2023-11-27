import Foundation

open class PublicKey: Codable, Identifiable {
    public var id: Int = -1
    public var key: String
    public var title: String
    public var url: String
    public var isReadOnly: Bool
    public var isVerified: Bool
    public var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case key
        case title
        case url
        case isReadOnly = "read_only"
        case isVerified = "verified"
        case createdAt = "created_at"
    }
}


public extension Octokit {
    func postPublicKey(
        title: String,
        key: String
    ) async throws -> PublicKey {
        struct Body: Codable {
            var title: String
            var key: String
        }

        let body = Body(title: title, key: key)
        let request = try URLRequestBuilder(path: "user/keys")
            .method(.post)
            .accept(.applicationGitHubJSON)
            .jsonBody(body, encoder: encoder, setContentLength: true)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        return try await session.json(for: request, decoder: decoder)
    }
}
