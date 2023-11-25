import OctoKit
import XCTest

class FollowTests: XCTestCase {
    func testGetMyFollowers() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/followers", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "users", statusCode: 200)
        let users = try await Octokit(config, session: session).myFollowers()
        XCTAssertEqual(users.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersFollowers() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/followers", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let users = try await Octokit(session: session).followers(name: "octocat")
        XCTAssertEqual(users.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetMyFollowing() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/following", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "users", statusCode: 200)
        let users = try await Octokit(config, session: session).myFollowing()
        XCTAssertEqual(users.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersFollowing() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/following", expectedHTTPMethod: "GET", jsonFile: "users", statusCode: 200)
        let users = try await Octokit(session: session).following(name: "octocat")
        XCTAssertEqual(users.count, 1)
        XCTAssertTrue(session.wasCalled)
    }
}
