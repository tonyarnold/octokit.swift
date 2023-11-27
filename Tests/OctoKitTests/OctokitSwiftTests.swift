import OctoKit
import XCTest

let enterpriseURL = URL(string: "https://enterprise.myserver.com")!

class OctokitSwiftTests: XCTestCase {
    func testOctokitInitializerWithEmptyConfig() {
        let subject = Octokit()
        XCTAssertEqual(subject.configuration.apiEndpoint, URL(string: "https://api.github.com"))
    }

    func testOctokitInitializerWithConfig() {
        let config = TokenConfiguration("12345", url: enterpriseURL)
        let subject = Octokit(configuration: config)
        XCTAssertEqual(subject.configuration.apiEndpoint, URL(string: "https://enterprise.myserver.com"))
    }
}
