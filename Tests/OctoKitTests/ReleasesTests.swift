import OctoKit
import XCTest

final class ReleasesTests: XCTestCase {
    // MARK: Actual Request tests

    func testListReleasesCustomLimit() async throws {
        let perPage = (0 ... 50).randomElement()!
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/releases?per_page=\(perPage)",
            method: .get,
            fileName: "releases"
        )

        let _ = try await Octokit(session: session).listReleases(owner: "octocat", repository: "Hello-World", perPage: perPage)
    }

    func testListReleases() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/releases?per_page=30",
            method: .get,
            fileName: "releases"
        )

        let releases = try await Octokit(session: session).listReleases(owner: "octocat", repository: "Hello-World")
        XCTAssertEqual(releases.count, 2)
        if let release = releases.first {
            XCTAssertEqual(release.tagName, "v1.0.0")
            XCTAssertEqual(release.commitish, "master")
            XCTAssertEqual(release.name, "v1.0.0 Release")
            XCTAssertEqual(release.body, "The changelog of this release")
            XCTAssertFalse(release.prerelease)
            XCTAssertTrue(release.draft)
            XCTAssertNil(release.tarballURL)
            XCTAssertNil(release.zipballURL)
            XCTAssertNil(release.publishedAt)
        } else {
            XCTFail("Failed to unwrap `releases.first`")
        }
        if let release = releases.last {
            XCTAssertEqual(release.tagName, "v1.0.0")
            XCTAssertEqual(release.commitish, "master")
            XCTAssertEqual(release.name, "v1.0.0 Release")
            XCTAssertEqual(release.body, "The changelog of this release")
            XCTAssertFalse(release.prerelease)
            XCTAssertFalse(release.draft)
            XCTAssertEqual(release.tarballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/tarball/v1.0.0")
            XCTAssertEqual(release.zipballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/zipball/v1.0.0")
            XCTAssertEqual(release.publishedAt, Date(timeIntervalSince1970: 1_361_993_732.0))
        } else {
            XCTFail("Failed to unwrap `releases.last`")
        }
    }

    func testGetLatestRelease() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/releases/latest",
            method: .get,
            fileName: "latest_release"
        )

        let release = try await Octokit(session: session).getLatestRelease(owner: "octocat", repository: "Hello-World")
        XCTAssertNotNil(release)

        XCTAssertEqual(release.tagName, "v1.0.0")
        XCTAssertEqual(release.commitish, "master")
        XCTAssertEqual(release.name, "v1.0.0")
        XCTAssertEqual(release.body, "Description of the release")
        XCTAssertFalse(release.prerelease)
        XCTAssertFalse(release.draft)
        XCTAssertNotNil(release.tarballURL)
        XCTAssertNotNil(release.zipballURL)
        XCTAssertNotNil(release.publishedAt)
    }

    func testPostRelease() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/releases",
            method: .post,
            statusCode: 201,
            fileName: "post_release"
        )

        let release = try await Octokit(session: session).postRelease(
            owner: "octocat",
            repository: "Hello-World",
            tagName: "v1.0.0",
            targetCommitish: "master",
            name: "v1.0.0 Release",
            body: "The changelog of this release",
            prerelease: false,
            draft: false,
            generateNotes: false
        )
        XCTAssertEqual(release.tagName, "v1.0.0")
        XCTAssertEqual(release.commitish, "master")
        XCTAssertEqual(release.name, "v1.0.0 Release")
        XCTAssertEqual(release.body, "The changelog of this release")
        XCTAssertFalse(release.prerelease)
        XCTAssertFalse(release.draft)
    }

    func testReleaseTagName() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/releases/tags/v1.0.0",
            method: .get,
            statusCode: 201,
            fileName: "release"
        )

        let release = try await Octokit(session: session).release(owner: "octocat", repository: "Hello-World", tag: "v1.0.0")
        XCTAssertEqual(release.tagName, "v1.0.0")
        XCTAssertEqual(release.commitish, "master")
        XCTAssertEqual(release.name, "v1.0.0 Release")
        XCTAssertEqual(release.body, "The changelog of this release")
        XCTAssertFalse(release.prerelease)
        XCTAssertFalse(release.draft)
        XCTAssertEqual(release.tarballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/tarball/v1.0.0")
        XCTAssertEqual(release.zipballURL?.absoluteString, "https://api.github.com/repos/octocat/Hello-World/zipball/v1.0.0")
        XCTAssertEqual(release.publishedAt, Date(timeIntervalSince1970: 1_361_993_732.0))
    }
}
