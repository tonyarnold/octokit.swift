import OctoKit
import XCTest

class LabelTests: XCTestCase {
    // MARK: Request Tests

    func testGetLabel() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels/bug", expectedHTTPMethod: "GET", jsonFile: "label", statusCode: 200)
        let label = try await Octokit(session: session).label(owner: "octocat", repository: "hello-world", name: "bug")
        XCTAssertEqual(label.name, "bug")
        XCTAssertTrue(session.wasCalled)
    }

    func testGetLabelEncodesSpaceCorrectly() async throws {
        throw XCTSkip("There is no label in the provided repository matching \"help wanted\".")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels/help%20wanted", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 200)

        let _ = try await Octokit(session: session).label(owner: "octocat", repository: "hello-world", name: "help wanted")
        XCTAssertTrue(session.wasCalled)
    }

    func testGetLabels() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "labels", statusCode: 200)
        let labels = try await Octokit(session: session).labels(owner: "octocat", repository: "hello-world")
        XCTAssertEqual(labels.count, 7)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetLabelsSetsPagination() async throws {
        throw XCTSkip("There are not enough labels present in the repository to test this case.")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels?page=2&per_page=50", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 200)
        let _ = try await Octokit(session: session).labels(owner: "octocat", repository: "hello-world", page: "2", perPage: "50")
        XCTAssertTrue(session.wasCalled)
    }

    func testCreateLabel() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/labels", expectedHTTPMethod: "POST", jsonFile: "label", statusCode: 200)
        let label = try await Octokit(session: session).postLabel(owner: "octocat", repository: "hello-world", name: "test label", color: "ffffff")
        XCTAssertNotNil(label)
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Parsing Tests

    func testParsingLabel() {
        let label = Helper.codableFromFile("label", type: Label.self)
        XCTAssertEqual(label.name, "bug")
        XCTAssertEqual(label.color, "fc2929")
        XCTAssertEqual(label.url, URL(string: "https://api.github.com/repos/octocat/hello-worId/labels/bug")!)
    }
}
