import OctoKit
import XCTest

class IssueTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyIssuesAsync() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/issues?page=1&per_page=100&state=open",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "issues",
                                            statusCode: 200)
        let issues = try await Octokit(config, session: session).myIssues()
        XCTAssertEqual(issues.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetIssueAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/1347", expectedHTTPMethod: "GET", jsonFile: "issue", statusCode: 200)
        let issue = try await Octokit(session: session).issue(owner: "octocat", repository: "Hello-World", number: 1347)
        XCTAssertEqual(issue.number, 1347)
        XCTAssertTrue(session.wasCalled)
    }

    func testPostIssueAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues", expectedHTTPMethod: "POST", jsonFile: "issue2", statusCode: 200)
        let issue = try await Octokit(session: session).postIssue(owner: "octocat", repository: "Hello-World", title: "Title", body: "Body")
        XCTAssertEqual(issue.number, 36)
        XCTAssertTrue(session.wasCalled)
    }

    func testPostCommentAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/1/comments",
                                            expectedHTTPMethod: "POST",
                                            jsonFile: "issue_comment",
                                            statusCode: 201)
        let comment = try await Octokit(session: session).commentIssue(owner: "octocat", repository: "Hello-World", number: 1, body: "Testing a comment")
        XCTAssertEqual(comment.body, "Testing a comment")
        XCTAssertTrue(session.wasCalled)
    }

    func testCommentsIssueAsync() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/1/comments?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "issue_comments",
                                            statusCode: 200)
        let comments = try await Octokit(session: session).issueComments(owner: "octocat", repository: "Hello-World", number: 1)
        XCTAssertEqual(comments.count, 1)
        XCTAssertEqual(comments[0].body, "Testing fetching comments for an issue")
        XCTAssertEqual(comments[0].reactions!.totalCount, 5)
        XCTAssertTrue(session.wasCalled)
    }

    func testPatchComment() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/Hello-World/issues/comments/1", expectedHTTPMethod: "POST", jsonFile: "issue_comment", statusCode: 201)
        let comment = try await Octokit(session: session).patchIssueComment(owner: "octocat", repository: "Hello-World", number: 1, body: "Testing a comment")
            XCTAssertEqual(comment.body, "Testing a comment")
        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testParsingIssue() {
        let subject = Helper.codableFromFile("issue", type: Issue.self)
        XCTAssertEqual(subject.user?.login, "octocat")
        XCTAssertEqual(subject.user?.id, 1)

        XCTAssertEqual(subject.id, 1)
        XCTAssertEqual(subject.number, 1347)
        XCTAssertEqual(subject.title, "Found a bug")
        XCTAssertEqual(subject.htmlURL, URL(string: "https://github.com/octocat/Hello-World/issues/1347"))
        XCTAssertEqual(subject.state, Openness.open)
        XCTAssertEqual(subject.locked, false)
    }

    func testParsingIssue2() {
        let subject = Helper.codableFromFile("issue2", type: Issue.self)
        XCTAssertEqual(subject.user?.login, "vincode-io")
        XCTAssertEqual(subject.user?.id, 16_448_027)

        XCTAssertEqual(subject.id, 427_231_234)
        XCTAssertEqual(subject.number, 36)
        XCTAssertEqual(subject.title, "Add Request: Test File")
        XCTAssertEqual(subject.htmlURL, URL(string: "https://github.com/vincode-io/FeedCompass/issues/36"))
        XCTAssertEqual(subject.state, Openness.open)
        XCTAssertEqual(subject.locked, false)
    }
}
