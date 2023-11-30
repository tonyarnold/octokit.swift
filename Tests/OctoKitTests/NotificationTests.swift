import OctoKit
import XCTest

class NotificationTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetMyNotifications() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/notifications?all=false&page=1&participating=false&per_page=100",
            method: .get,
            headers: headers,
            fileName: "notification_threads"
        )

        let notifications = try await Octokit(configuration: config, session: session).myNotifications(all: false, participating: false, page: 1, perPage: 100)
        XCTAssertEqual(notifications.count, 1)
        XCTAssertEqual(notifications.first?.id, "1")
    }

    func testMarkNotifcationsRead() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/notifications?last_read_at=last_read_at&read=false",
            method: .put,
            headers: headers,
            fileName: nil
        )
        try await Octokit(configuration: config, session: session).markNotificationsRead()
    }

    func testGetNotificationThread() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/notifications/threads/1",
            method: .get,
            headers: headers,
            fileName: "notification_thread"
        )

        let notification = try await Octokit(configuration: config, session: session).getNotificationThread(threadID: "1")
        XCTAssertEqual(notification.id, "1")
    }

    func testGetThreadSubscription() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/notifications/threads/1/subscription",
            method: .get,
            headers: headers,
            fileName: "notification_thread_subscription"
        )

        let notification = try await Octokit(configuration: config, session: session).getThreadSubscription(threadID: "1")
        XCTAssertEqual(notification.id, 1)
    }

    func testSetThreadSubscription() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/notifications/threads/1/subscription",
            method: .put,
            headers: headers,
            fileName: "notification_thread_subscription"
        )

        let notification = try await Octokit(configuration: config, session: session).setThreadSubscription(threadID: "1")
        XCTAssertEqual(notification.id, 1)
    }

    func testDeleteThreadSubscription() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/notifications/threads/1/subscription",
            method: .delete,
            headers: headers,
            fileName: nil
        )

        try await Octokit(configuration: config, session: session).deleteThreadSubscription(threadID: "1")
    }

    func testListRepositoryNotifications() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/hello-world/notifications?all=false&page=1&participating=false&perPage=100",
            method: .get,
            headers: headers,
            fileName: "notification_threads"
        )
        let notifications = try await Octokit(configuration: config, session: session).listRepositoryNotifications(owner: "octocat", repository: "hello-world")
        XCTAssertEqual(notifications.count, 1)
        XCTAssertEqual(notifications.first?.id, "1")
    }

    func testMarkRepositoryNofificationsRead() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/octocat/hello-world/notifications",
            method: .put,
            headers: headers,
            fileName: nil
        )

        try await Octokit(configuration: config, session: session).markRepositoryNotificationsRead(owner: "octocat", repository: "hello-world")
    }
}
