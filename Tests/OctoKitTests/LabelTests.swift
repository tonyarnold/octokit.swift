import OctoKit
import XCTest

class LabelTests: XCTestCase {
    // MARK: Request Tests

    func testGetLabel() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/hello-world/labels/bug",
            method: .get,
            fileName: "label"
        )

        let label = try await Octokit(session: session).label(owner: "octocat", repository: "hello-world", name: "bug")
        XCTAssertEqual(label.name, "bug")
    }

    func testGetLabelEncodesSpaceCorrectly() async throws {
        throw XCTSkip("There is no label in the provided repository matching \"help wanted\".")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/hello-world/labels/help%20wanted",
            method: .get,
            fileName: nil
        )

        let _ = try await Octokit(session: session).label(owner: "octocat", repository: "hello-world", name: "help wanted")
    }

    func testGetLabels() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/hello-world/labels?page=1&per_page=100",
            method: .get,
            fileName: "labels"
        )

        let labels = try await Octokit(session: session).labels(owner: "octocat", repository: "hello-world")
        XCTAssertEqual(labels.count, 7)
    }

    func testGetLabelsSetsPagination() async throws {
        throw XCTSkip("There are not enough labels present in the repository to test this case.")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/hello-world/labels?page=2&per_page=50",
            method: .get,
            fileName: nil
        )

        let _ = try await Octokit(session: session).labels(owner: "octocat", repository: "hello-world", page: "2", perPage: "50")
    }

    func testCreateLabel() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/hello-world/labels",
            method: .post,
            fileName: "label"
        )

        let label = try await Octokit(session: session).postLabel(owner: "octocat", repository: "hello-world", name: "test label", color: "ffffff")
        XCTAssertNotNil(label)
    }

    // MARK: Parsing Tests

    func testParsingLabel() {
        let label = Helper.codableFromFile("label", type: Label.self)
        XCTAssertEqual(label.name, "bug")
        XCTAssertEqual(label.color, "fc2929")
        XCTAssertEqual(label.url, URL(string: "https://api.github.com/repos/octocat/hello-worId/labels/bug")!)
    }
}
