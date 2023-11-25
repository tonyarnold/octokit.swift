
import Foundation
import OctoKit
import XCTest

class GistTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyGists() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "gists",
                                            statusCode: 200)
        let gists = try await Octokit(config, session: session).myGists()
        XCTAssertEqual(gists.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetGists() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/vincode-io/gists?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "gists",
                                            statusCode: 200)
        let gists = try await Octokit(config, session: session).gists(owner: "vincode-io")
        XCTAssertEqual(gists.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetGist() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "GET", jsonFile: "gist", statusCode: 200)
        let gist = try await Octokit(session: session).gist(id: "aa5a315d61ae9438b18d")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
        XCTAssertTrue(session.wasCalled)
    }

    func testPostGist() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        do {
            let gist = try await Octokit(session: session).postGistFile(description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program", publicAccess: true)
            XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
            XCTAssertTrue(session.wasCalled)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPatchGist() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/gists/aa5a315d61ae9438b18d", expectedHTTPMethod: "POST", jsonFile: "gist", statusCode: 200)
        let gist = try await Octokit(session: session).patchGistFile(id: "aa5a315d61ae9438b18d", description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
        XCTAssertTrue(session.wasCalled)
    }
}
