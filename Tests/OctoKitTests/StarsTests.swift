import OctoKit
import XCTest

class StarsTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetStarredRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/starred",
            method: "GET",
            headers: headers,
            fileName: "user_repos"
        )

        let repositories = try await Octokit(configuration: config, session: session).myStars()
        XCTAssertEqual(repositories.count, 1)
    }

    func testFailToGetStarredRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/starred",
            method: "GET",
            statusCode: 404,
            headers: headers,
            fileName: nil
        )

        do {
            let _ = try await Octokit(configuration: config, session: session).myStars()
            XCTFail("Should not retrieve repositories")
        } catch let error as APIRequestRouterError {
            switch error {
                case let .unsuccessfulRequest(statusCode, _):
                    XCTAssertEqual(statusCode, 404)

                default:
                    XCTFail("Unexpected APIRequestRouterError error case")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testGetUsersStarredRepositories() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/users/octocat/starred",
            method: "GET",
            fileName: "user_repos"
        )

        let repositories = try await Octokit(session: session).stars(name: "octocat")
        XCTAssertEqual(repositories.count, 1)
    }

    func testFailToGetUsersStarredRepositories() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/users/octocat/starred",
            method: "GET",
            statusCode: 404,
            fileName: nil
        )

        do {
            let _ = try await Octokit(session: session).stars(name: "octocat")
            XCTFail("Should not retrieve repositories")
        } catch let error as APIRequestRouterError {
            switch error {
                case let .unsuccessfulRequest(statusCode, _):
                    XCTAssertEqual(statusCode, 404)

                default:
                    XCTFail("Unexpected APIRequestRouterError error case")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testGetStarFromNotStarredRepository() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/starred/octocat/Hello-World",
            method: "GET",
            statusCode: 404,
            fileName: nil
        )

        let flag = try await Octokit(session: session).star(owner: "octocat", repository: "Hello-World")
        XCTAssertFalse(flag)
    }

    func testGetStarFromStarredRepository() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/starred/octocat/Hello-World",
            method: "GET",
            statusCode: 204,
            fileName: nil
        )

        let flag = try await Octokit(session: session).star(owner: "octocat", repository: "Hello-World")
        XCTAssertTrue(flag)
    }

    func testPutStar() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/starred/octocat/Hello-World",
            method: "PUT",
            statusCode: 204,
            fileName: nil
        )

        let _ = try await Octokit(session: session).putStar(owner: "octocat", repository: "Hello-World")
    }

    func testDeleteStar() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/starred/octocat/Hello-World",
            method: "DELETE",
            statusCode: 204,
            fileName: nil
        )

        let _ = try await Octokit(session: session).deleteStar(owner: "octocat", repository: "Hello-World")
    }
}
