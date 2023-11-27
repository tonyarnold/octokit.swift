import Foundation

public extension Octokit {
    /// Deletes a reference.
    /// - Parameters:
    ///   - owner: The user or organization that owns the repositories.
    ///   - repo: The repository on which the reference needs to be deleted.
    ///   - reference: The reference to delete.
    func deleteReference(
        owner: String,
        repository: String,
        reference: String
    ) async throws {
        let request = URLRequestBuilder(path: "repos/\(owner)/\(repository)/git/refs/\(reference)")
            .method(.delete)
            .accept(.applicationGitHubJSON)
            .configureAuthorization(using: configuration)
            .makeRequest(withBaseURL: configuration.apiEndpoint)

        try await session.sendRequest(for: request)
    }
}
