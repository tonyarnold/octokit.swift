import OctoKit
import RequestKit
import XCTest

class PublicKeyTests: XCTestCase {
    // MARK: Actual Request tests

    func testPostPublicKey() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/keys", expectedHTTPMethod: "POST", expectedHTTPHeaders: headers, jsonFile: "public_key", statusCode: 201)
        let publicKey = try await Octokit(config, session: session).postPublicKey(publicKey: "test-key", title: "test title")
        XCTAssertEqual(publicKey, "test-key")
        XCTAssertTrue(session.wasCalled)
    }
}
