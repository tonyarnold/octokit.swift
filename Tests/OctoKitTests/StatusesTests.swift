import OctoKit
import XCTest

class StatusesTests: XCTestCase {
    func testCreateCommitStatus() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e",
            method: "POST",
            statusCode: 201,
            fileName: "status"
        )

        let status = try await Octokit(session: session).createCommitStatus(
            owner: "octocat",
            repository: "Hello-World",
            sha: "6dcb09b5b57875f334f61aebed695e2e4193db5e",
            state: .success,
            targetURL: "https://example.com/build/status",
            description: "The build succeeded!",
            context: "continuous-integration/jenkins"
        )
        XCTAssertEqual(status.id, 1)
        XCTAssertEqual(status.url, "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(status.avatarURL, "https://github.com/images/error/hubot_happy.gif")
        XCTAssertEqual(status.nodeID, "MDY6U3RhdHVzMQ==")
        XCTAssertEqual(status.state, Status.State.success)
        XCTAssertEqual(status.description, "Build has completed successfully")
        XCTAssertEqual(status.targetURL, "https://ci.example.com/1000/output")
        XCTAssertEqual(status.context, "continuous-integration/jenkins")
        XCTAssertEqual(status.creator?.login, "octocat")
    }

    func testListCommitStatuses() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/Hello-World/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e/statuses",
            method: "GET",
            fileName: "statuses"
        )

        let statuses = try await Octokit(session: session).listCommitStatuses(owner: "octocat", repository: "Hello-World", ref: "6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(statuses.count, 1)
        XCTAssertEqual(statuses.first?.id, 1)
        XCTAssertEqual(statuses.first?.url, "https://api.github.com/repos/octocat/Hello-World/statuses/6dcb09b5b57875f334f61aebed695e2e4193db5e")
        XCTAssertEqual(statuses.first?.avatarURL, "https://github.com/images/error/hubot_happy.gif")
        XCTAssertEqual(statuses.first?.nodeID, "MDY6U3RhdHVzMQ==")
        XCTAssertEqual(statuses.first?.state, Status.State.success)
        XCTAssertEqual(statuses.first?.description, "Build has completed successfully")
        XCTAssertEqual(statuses.first?.targetURL, "https://ci.example.com/1000/output")
        XCTAssertEqual(statuses.first?.context, "continuous-integration/jenkins")
        XCTAssertEqual(statuses.first?.creator?.login, "octocat")
    }
}
