import OctoKit
import XCTest

class RepositoryTests: XCTestCase {
    func testGetRepositories() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/users/octocat/repos?page=1&per_page=100",
            method: "GET",
            statusCode: 200,
            fileName: "user_repos"
        )

        let repositories = try await Octokit(session: session).repositories(owner: "octocat")
        XCTAssertEqual(repositories.count, 1)
    }

    func testGetRepositoriesEnterprise() async throws {
        let config = TokenConfiguration(url: URL(string: "https://enterprise.nerdishbynature.com/api/v3/")!)
        let session = try URLSession.mockedSession(
            url: "https://enterprise.nerdishbynature.com/api/v3/users/octocat/repos?page=1&per_page=100",
            method: "GET",
            fileName: "user_repos"
        )

        let repositories = try await Octokit(configuration: config, session: session).repositories(owner: "octocat")
        XCTAssertEqual(repositories.count, 1)
    }

    func testGetAuthenticatedRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/repos?page=1&per_page=100",
            method: "GET",
            headers: headers,
            fileName: "user_repos"
        )
        let repositories = try await Octokit(configuration: config, session: session).repositories()
        XCTAssertEqual(repositories.count, 1)
    }

    func testGetAuthenticatedRepositoriesEnterprise() async throws {
        let config = TokenConfiguration("user:12345", url: URL(string: "https://enterprise.nerdishbynature.com/api/v3/")!)
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = try URLSession.mockedSession(
            url: "https://enterprise.nerdishbynature.com/api/v3/user/repos?page=1&per_page=100",
            method: "GET",
            headers: headers,
            fileName: "user_repos"
        )
        let repositories = try await Octokit(configuration: config, session: session).repositories()
        XCTAssertEqual(repositories.count, 1)
    }

    func testFailToGetRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/user/repos?page=1&per_page=100",
            method: "GET",
            statusCode: 401,
            headers: headers,
            rawResponse: json
        )

        do {
            let _ = try await Octokit(configuration: config, session: session).repositories()
            XCTFail("Should not retrieve repositories")
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

    func testGetRepository() async throws {
        let (owner, name) = ("mietzmithut", "Test")
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/mietzmithut/Test",
            method: "GET",
            fileName: "repo"
        )
        let repo = try await Octokit(session: session).repository(owner: owner, name: name)
        XCTAssertEqual(repo.name, name)
        XCTAssertEqual(repo.owner.login, owner)
    }

    func testGetRepositoryEnterprise() async throws {
        let config = TokenConfiguration(url: URL(string: "https://enterprise.nerdishbynature.com/api/v3/")!)
        let (owner, name) = ("mietzmithut", "Test")
        let session = try URLSession.mockedSession(
            url: "https://enterprise.nerdishbynature.com/api/v3/repos/mietzmithut/Test",
            method: "GET",
            fileName: "repo"
        )

        let repo = try await Octokit(configuration: config, session: session).repository(owner: owner, name: name)
        XCTAssertEqual(repo.name, name)
        XCTAssertEqual(repo.owner.login, owner)
    }

    func testFailToGetRepository() async throws {
        let session = try URLSession.mockedSession(
            url: "https://api.github.com/repos/mietzmithut/Test",
            method: "GET",
            statusCode: 404,
            fileName: nil
        )

        let (owner, name) = ("mietzmithut", "Test")

        do {
            let _ = try await Octokit(session: session).repository(owner: owner, name: name)
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

    // MARK: Model Tests

    func testUserParsingFullRepository() {
        let subject = Helper.codableFromFile("repo", type: Repository.self)
        XCTAssertEqual(subject.owner.login, "mietzmithut")
        XCTAssertEqual(subject.owner.id, 4_672_699)

        XCTAssertEqual(subject.id, 10_824_973)
        XCTAssertEqual(subject.name, "Test")
        XCTAssertEqual(subject.fullName, "mietzmithut/Test")
        XCTAssertEqual(subject.isPrivate, false)
        XCTAssertEqual(subject.description, "")
        XCTAssertEqual(subject.isFork, false)
        XCTAssertEqual(subject.gitURL, "git://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.sshURL, "git@github.com:mietzmithut/Test.git")
        XCTAssertEqual(subject.cloneURL, "https://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.size, 132)
    }
}
