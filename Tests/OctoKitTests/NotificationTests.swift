import OctoKit
import XCTest

class NotificationTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyNotifications() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?all=false&page=1&participating=false&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_threads",
                                            statusCode: 200)
        let notifications = try await Octokit(config, session: session).myNotifications(all: false, participating: false, page: "1", perPage: "100")
        XCTAssertEqual(notifications.count, 1)
        XCTAssertEqual(notifications.first?.id, "1")
        XCTAssertTrue(session.wasCalled)
    }

    func testMarkNotifcationsRead() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications?last_read_at=last_read_at&read=false",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        try await Octokit(config, session: session).markNotificationsRead()
        XCTAssertTrue(session.wasCalled)
    }

    func testGetNotificationThread() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread",
                                            statusCode: 200)
        let notification = try await Octokit(config, session: session).getNotificationThread(threadId: "1")
        XCTAssertEqual(notification.id, "1")
        XCTAssertTrue(session.wasCalled)
    }

    func testGetThreadSubscription() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread_subscription",
                                            statusCode: 200)
        let notification = try await Octokit(config, session: session).getThreadSubscription(threadId: "1")
        XCTAssertEqual(notification.id, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testSetThreadSubscription() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_thread_subscription",
                                            statusCode: 200)
        let notification = try await Octokit(config, session: session).setThreadSubscription(threadId: "1")
        XCTAssertEqual(notification.id, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testDeleteThreadSubscription() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/notifications/threads/1/subscription",
                                            expectedHTTPMethod: "DELETE",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        try await Octokit(config, session: session).deleteThreadSubscription(threadId: "1")
        XCTAssertTrue(session.wasCalled)
    }

    func testListRepositoryNotifications() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications?all=false&page=1&participating=false&perPage=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "notification_threads",
                                            statusCode: 200)
        let notifications = try await Octokit(config, session: session).listRepositoryNotifications(owner: "octocat", repository: "hello-world")
        XCTAssertEqual(notifications.count, 1)
        XCTAssertEqual(notifications.first?.id, "1")
        XCTAssertTrue(session.wasCalled)
    }

    func testMarkRepositoryNofificationsRead() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/octocat/hello-world/notifications",
                                            expectedHTTPMethod: "PUT",
                                            expectedHTTPHeaders: headers,
                                            response: "",
                                            statusCode: 200)
        try await Octokit(config, session: session).markRepositoryNotificationsRead(owner: "octocat", repository: "hello-world")
        XCTAssertTrue(session.wasCalled)
    }
}
