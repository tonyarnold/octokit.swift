import OctoKit
import XCTest

class StarsTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetStarredRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit(config, session: session).myStars()
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetStarredRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: nil, statusCode: 404)

        do {
            let _ = try await Octokit(config, session: session).myStars()
            XCTAssert(false, "should not retrieve repositories")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 404)
            XCTAssertEqual(error.domain, OctoKitErrorDomain)
        } catch {
            XCTAssert(false, "unexpected error type")
        }

        XCTAssertTrue(session.wasCalled)
    }

    func testGetUsersStarredRepositories() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let repositories =  try await Octokit(session: session).stars(name: "octocat")
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetUsersStarredRepositories() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/starred", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)

        do {
            let _ = try await Octokit(session: session).stars(name: "octocat")
            XCTAssert(false, "should not retrieve repositories")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 404)
            XCTAssertEqual(error.domain, OctoKitErrorDomain)
        } catch {
            XCTAssert(false, "unexpected error type")
        }

        XCTAssertTrue(session.wasCalled)
    }

    func testGetStarFromNotStarredRepository() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let flag = try await Octokit(session: session).star(owner: "octocat", repository: "Hello-World")
        XCTAssertFalse(flag)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetStarFromStarredRepository() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 204)
        let flag = try await Octokit(session: session).star(owner: "octocat", repository: "Hello-World")
        XCTAssertTrue(flag)
        XCTAssertTrue(session.wasCalled)
    }

    func testPutStar() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "PUT", jsonFile: nil, statusCode: 204)
        let _ = try await Octokit(session: session).putStar(owner: "octocat", repository: "Hello-World")
        XCTAssertTrue(session.wasCalled)
    }

    func testDeleteStar() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/starred/octocat/Hello-World", expectedHTTPMethod: "DELETE", jsonFile: nil, statusCode: 204)
        let _ = try await Octokit(session: session).deleteStar(owner: "octocat", repository: "Hello-World")
        XCTAssertTrue(session.wasCalled)
    }
}
