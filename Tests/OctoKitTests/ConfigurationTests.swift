import Foundation
import OctoKit
import XCTest

class ConfigurationTests: XCTestCase {
    func testTokenConfiguration() {
        let subject = TokenConfiguration("12345")
        XCTAssertEqual(subject.accessToken, "12345".data(using: .utf8)?.base64EncodedString())
        XCTAssertEqual(subject.apiEndpoint, URL(string: "https://api.github.com"))
        XCTAssertTrue(subject.customHeaders?.isEmpty ?? true)
    }

    func testEnterpriseTokenConfiguration() {
        let subject = TokenConfiguration("12345", url: enterpriseURL)
        XCTAssertEqual(subject.accessToken, "12345".data(using: .utf8)?.base64EncodedString())
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
    }

    func testOAuthConfiguration() {
        let subject = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, URL(string: "https://api.github.com"))
    }

    func testOAuthTokenConfiguration() {
        let subject = OAuthConfiguration(enterpriseURL, token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        XCTAssertEqual(subject.token, "12345")
        XCTAssertEqual(subject.secret, "6789")
        XCTAssertEqual(subject.apiEndpoint, enterpriseURL)
    }

    func testAccessTokenFromResponse() {
        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"])
        let response = "access_token=017ec60f4a182&scope=read%3Aorg%2Crepo&token_type=bearer"
        let expectation = "017ec60f4a182"
        XCTAssertEqual(config.accessTokenFromResponse(response), expectation)
    }

    func testHandleOpenURL() async throws {
        let response = "access_token=017ec60f4a182&scope=read%3Aorg%2Crepo&token_type=bearer"
        let session = try URLSession.mockedSession(
            url: "https://github.com/login/oauth/access_token",
            method: .get,
            rawResponse: response
        )

        let config = OAuthConfiguration(token: "12345", secret: "6789", scopes: ["repo", "read:org"], session: session)
        let url = URL(string: "urlscheme://authorize?code=dhfjgh23493&state=")!
        let token = try await config.handleOpenURL(url: url)
        XCTAssertNotNil(token)
        XCTAssertEqual(token?.accessToken, "017ec60f4a182".data(using: .utf8)?.base64EncodedString())
    }
}
