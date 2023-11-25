import OctoKit
import XCTest

class UserTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetUser() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/mietzmithut", expectedHTTPMethod: "GET", jsonFile: "user_mietzmithut", statusCode: 200)
        let username = "mietzmithut"
        let user = try await Octokit(session: session).user(name: username)
        XCTAssertEqual(user.login, username)
        XCTAssertNotNil(user.createdAt)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailingToGetUser() async throws {
        let username = "notexisting"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/notexisting", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)

        do {
            let _ = try await Octokit(session: session).user(name: username)
            XCTAssert(false, "should not retrieve repositories")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 404)
            XCTAssertEqual(error.domain, OctoKitErrorDomain)
        } catch {
            XCTAssert(false, "unexpected error type")
        }

        XCTAssertTrue(session.wasCalled)
    }

    func testGettingAuthenticatedUser() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user", expectedHTTPMethod: "GET", expectedHTTPHeaders: headers, jsonFile: "user_me", statusCode: 200)
        let user = try await Octokit(config, session: session).me()
        XCTAssertEqual(user.login, "pietbrauer")
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetAuthenticatedUser() async throws {
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user", expectedHTTPMethod: "GET", response: json, statusCode: 401)

        do {
            let _ = try await Octokit(session: session).me()
            XCTAssert(false, "should not retrieve user")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 401)
            XCTAssertEqual(error.domain, OctoKitErrorDomain)
        } catch {
            XCTAssert(false, "unexpected error type")
        }

        XCTAssertTrue(session.wasCalled)
    }

    // MARK: Model Tests

    func testUserParsingFullUser() {
        let subject = Helper.codableFromFile("user_me", type: User.self)
        XCTAssertEqual(subject.login, "pietbrauer")
        XCTAssertEqual(subject.id, 759_730)
        XCTAssertEqual(subject.avatarURL, "https://avatars.githubusercontent.com/u/759730?v=3")
        XCTAssertEqual(subject.gravatarID, "")
        XCTAssertEqual(subject.type, "User")
        XCTAssertEqual(subject.name, "Piet Brauer")
        XCTAssertEqual(subject.company, "XING AG")
        XCTAssertEqual(subject.blog, "xing.to/PietBrauer")
        XCTAssertEqual(subject.location, "Hamburg")
        XCTAssertNil(subject.email)
        XCTAssertEqual(subject.numberOfPublicRepos, 6)
        XCTAssertEqual(subject.numberOfPublicGists, 10)
        XCTAssertEqual(subject.numberOfPrivateRepos, 4)
        XCTAssertEqual(subject.nodeID, "MDQ6VXNlcjE=")
        XCTAssertEqual(subject.htmlURL, "https://github.com/pietbrauer")
        XCTAssertEqual(subject.followersURL, "https://api.github.com/users/pietbrauer/followers")
        XCTAssertEqual(subject.followingURL, "https://api.github.com/users/pietbrauer/following{/other_user}")
        XCTAssertEqual(subject.gistsURL, "https://api.github.com/users/pietbrauer/gists{/gist_id}")
        XCTAssertEqual(subject.starredURL, "https://api.github.com/users/pietbrauer/starred{/owner}{/repo}")
        XCTAssertEqual(subject.subscriptionsURL, "https://api.github.com/users/pietbrauer/subscriptions")
        XCTAssertEqual(subject.reposURL, "https://api.github.com/users/pietbrauer/repos")
        XCTAssertEqual(subject.eventsURL, "https://api.github.com/users/pietbrauer/events{/privacy}")
        XCTAssertEqual(subject.receivedEventsURL, "https://api.github.com/users/pietbrauer/received_events")
        XCTAssertFalse(subject.siteAdmin!)
        XCTAssertTrue(subject.hireable!)
        XCTAssertEqual(subject.bio, "Tweeting about iOS and Drumming")
        XCTAssertEqual(subject.twitterUsername, "pietbrauer")
        XCTAssertEqual(subject.numberOfFollowers, 41)
        XCTAssertEqual(subject.numberOfFollowing, 19)
        XCTAssertEqual(subject.createdAt?.timeIntervalSince1970, 1_304_110_716.0)
        XCTAssertEqual(subject.updatedAt?.timeIntervalSince1970, 1_421_091_743.0)
        XCTAssertEqual(subject.numberOfPrivateGists, 7)
        XCTAssertEqual(subject.numberOfOwnPrivateRepos, 4)
        XCTAssertEqual(subject.amountDiskUsage, 49064)
        XCTAssertEqual(subject.numberOfCollaborators, 2)
        XCTAssertNil(subject.twoFactorAuthenticationEnabled)
        XCTAssertEqual(subject.subscriptionPlan?.name, "micro")
    }

    func testUserParsingMinimalUser() {
        let subject = Helper.codableFromFile("user_mietzmithut", type: User.self)
        XCTAssertEqual(subject.login, "mietzmithut")
        XCTAssertEqual(subject.id, 4_672_699)
        XCTAssertEqual(subject.avatarURL, "https://avatars.githubusercontent.com/u/4672699?v=3")
        XCTAssertEqual(subject.gravatarID, "")
        XCTAssertEqual(subject.type, "User")
        XCTAssertEqual(subject.name, "Julia Kallenberg")
        XCTAssertEqual(subject.company, "")
        XCTAssertEqual(subject.blog, "")
        XCTAssertEqual(subject.location, "Hamburg")
        XCTAssertEqual(subject.email, "")
        XCTAssertEqual(subject.numberOfPublicRepos, 7)
        XCTAssertEqual(subject.numberOfPublicGists, 0)
        XCTAssertNil(subject.numberOfPrivateRepos)
    }
}
