import OctoKit
import XCTest

class UserTests: XCTestCase {
    func testGetUser() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/users/mietzmithut",
            method: "GET",
            fileName: "user_mietzmithut"
        )

        let username = "mietzmithut"
        let user = try await Octokit(session: session).user(name: username)
        XCTAssertEqual(user.login, username)
        XCTAssertNotNil(user.createdAt)
    }

    func testFailingToGetUser() async throws {
        let username = "notexisting"
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/users/notexisting",
            method: "GET",
            statusCode: 404,
            fileName: nil
        )

        do {
            let _ = try await Octokit(session: session).user(name: username)
            XCTFail("Should not retrieve repositories")
        } catch let error as APIRequestRouterError {
            switch error {
                case let .unsuccessfulRequest(statusCode, _):
                    XCTAssertEqual(statusCode, 404)

                default:
                    XCTFail("Unexpected APIRequestRouterError error case")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
    }

    func testGettingAuthenticatedUser() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user",
            method: "GET",
            headers: headers,
            fileName: "user_me"
        )

        let user = try await Octokit(configuration: config, session: session).me()
        XCTAssertEqual(user.login, "pietbrauer")
    }

    func testFailToGetAuthenticatedUser() async throws {
        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user",
            method: "GET",
            statusCode: 401,
            rawResponse: json
        )

        do {
            let _ = try await Octokit(session: session).me()
            XCTFail("Should not retrieve user")
        } catch let error as APIRequestRouterError {
            switch error {
                case let .unsuccessfulRequest(statusCode, _):
                    XCTAssertEqual(statusCode, 401)

                default:
                    XCTFail("Unexpected APIRequestRouterError error case")
            }
        } catch {
            XCTFail("Unexpected error type")
        }
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
