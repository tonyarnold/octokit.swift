import OctoKit
import XCTest

class RepositoryTests: XCTestCase {
    // MARK: Actual Request tests

    func testGetRepositories() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/users/octocat/repos?page=1&per_page=100", expectedHTTPMethod: "GET", jsonFile: "user_repos", statusCode: 200)
        let repositories = try await Octokit(session: session).repositories(owner: "octocat")
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepositoriesEnterprise() async throws {
        let config = TokenConfiguration(url: "https://enterprise.nerdishbynature.com/api/v3/")
        let session = OctoKitURLTestSession(expectedURL: "https://enterprise.nerdishbynature.com/api/v3/users/octocat/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            jsonFile: "user_repos",
                                            statusCode: 200)
        let repositories = try await Octokit(config, session: session).repositories(owner: "octocat")
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetAuthenticatedRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "user_repos",
                                            statusCode: 200)
        let repositories = try await Octokit(config, session: session).repositories()
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetAuthenticatedRepositoriesEnterprise() async throws {
        let config = TokenConfiguration("user:12345", url: "https://enterprise.nerdishbynature.com/api/v3/")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let session = OctoKitURLTestSession(expectedURL: "https://enterprise.nerdishbynature.com/api/v3/user/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            jsonFile: "user_repos",
                                            statusCode: 200)
        let repositories = try await Octokit(config, session: session).repositories()
        XCTAssertEqual(repositories.count, 1)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepositories() async throws {
        let config = TokenConfiguration("user:12345")
        let headers = Helper.makeAuthHeader(username: "user", password: "12345")

        let json = "{\"message\":\"Bad credentials\",\"documentation_url\":\"https://developer.github.com/v3\"}"
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/user/repos?page=1&per_page=100",
                                            expectedHTTPMethod: "GET",
                                            expectedHTTPHeaders: headers,
                                            response: json,
                                            statusCode: 401)

        do {
            let _ = try await Octokit(config, session: session).repositories()
            XCTAssert(false, "should not retrieve repositories")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 401)
            XCTAssertEqual(error.domain, OctoKitErrorDomain)
        } catch {
            XCTAssert(false, "unexpected error type")
        }

        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepository() async throws {
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let repo = try await Octokit(session: session).repository(owner: owner, name: name)
        XCTAssertEqual(repo.name, name)
        XCTAssertEqual(repo.owner.login, owner)
        XCTAssertTrue(session.wasCalled)
    }

    func testGetRepositoryEnterprise() async throws {
        let config = TokenConfiguration(url: "https://enterprise.nerdishbynature.com/api/v3/")
        let (owner, name) = ("mietzmithut", "Test")
        let session = OctoKitURLTestSession(expectedURL: "https://enterprise.nerdishbynature.com/api/v3/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: "repo", statusCode: 200)
        let repo = try await Octokit(config, session: session).repository(owner: owner, name: name)
        XCTAssertEqual(repo.name, name)
        XCTAssertEqual(repo.owner.login, owner)
        XCTAssertTrue(session.wasCalled)
    }

    func testFailToGetRepository() async throws {
        let session = OctoKitURLTestSession(expectedURL: "https://api.github.com/repos/mietzmithut/Test", expectedHTTPMethod: "GET", jsonFile: nil, statusCode: 404)
        let (owner, name) = ("mietzmithut", "Test")

        do {
            let _ = try await Octokit(session: session).repository(owner: owner, name: name)
            XCTAssert(false, "should not retrieve repositories")
        } catch let error as NSError {
            XCTAssertEqual(error.code, 404)
            XCTAssertEqual(error.domain, OctoKitErrorDomain)
        } catch {
            XCTAssert(false, "unexpected error type")
        }

        XCTAssertTrue(session.wasCalled)
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
        XCTAssertEqual(subject.repositoryDescription, "")
        XCTAssertEqual(subject.isFork, false)
        XCTAssertEqual(subject.gitURL, "git://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.sshURL, "git@github.com:mietzmithut/Test.git")
        XCTAssertEqual(subject.cloneURL, "https://github.com/mietzmithut/Test.git")
        XCTAssertEqual(subject.size, 132)
    }
}
