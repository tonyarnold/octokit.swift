import OctoKit
import XCTest

class PublicKeyTests: XCTestCase {
    func testPostPublicKey() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/keys",
            method: .post,
            statusCode: 201,
            headers: headers,
            fileName: "public_key"
        )

        let publicKey = try await Octokit(configuration: config, session: session).postPublicKey(title: "test title", key: "test-key")
        XCTAssertEqual(publicKey.key, "ssh-rsa AAA...")
    }
}
