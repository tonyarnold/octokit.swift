import OctoKit
import XCTest

class FollowTests: XCTestCase {
    func testGetMyFollowers() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/followers",
            method: "GET",
            headers: headers,
            fileName: "users"
        )

        let users = try await Octokit(configuration: config, session: session).myFollowers()
        XCTAssertEqual(users.count, 1)
    }

    func testGetUsersFollowers() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/followers",
            method: "GET",
            fileName: "users"
        )

        let users = try await Octokit(session: session).followers(name: "octocat")
        XCTAssertEqual(users.count, 1)
    }

    func testGetMyFollowing() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/followers",
            method: "GET",
            headers: headers,
            fileName: "users"
        )

        let users = try await Octokit(configuration: config, session: session).myFollowing()
        XCTAssertEqual(users.count, 1)
    }

    func testGetUsersFollowing() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/followers",
            method: "GET",
            fileName: "users"
        )

        let users = try await Octokit(session: session).following(name: "octocat")
        XCTAssertEqual(users.count, 1)
    }
}
