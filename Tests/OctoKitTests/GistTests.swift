
import Foundation
import OctoKit
import XCTest

class GistTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyGists() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/gists?page=1&per_page=100",
            method: "GET",
            headers: headers,
            fileName: "gists"
        )

        let gists = try await Octokit(configuration: config, session: session).myGists()
        XCTAssertEqual(gists.count, 1)
    }

    func testGetGists() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/users/vincode-io/gists?page=1&per_page=100",
            method: "GET",
            headers: headers,
            fileName: "gists"
        )

        let gists = try await Octokit(configuration: config, session: session).gists(owner: "vincode-io")
        XCTAssertEqual(gists.count, 1)
    }

    func testGetGist() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/gists/aa5a315d61ae9438b18d",
            method: "GET",
            fileName: "gist"
        )
        let gist = try await Octokit(session: session).gist(id: "aa5a315d61ae9438b18d")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
    }

    func testPostGist() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/gists",
            method: "POST",
            fileName: "gist"
        )

        do {
            let gist = try await Octokit(session: session).postGistFile(description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program", isPublic: true)
            XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPatchGist() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/gists/aa5a315d61ae9438b18d",
            method: "POST",
            fileName: "gist"
        )

        let gist = try await Octokit(session: session).patchGistFile(id: "aa5a315d61ae9438b18d", description: "Test Post", filename: "Hello-World.swift", fileContent: "Sample Program")
        XCTAssertEqual(gist.id, "aa5a315d61ae9438b18d")
    }
}
