import Foundation
import XCTest
@testable import OctoKit

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if let data {
                client?.urlProtocol(self, didLoad: data)
            }

            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

extension URLSession {
    static func mockedSession(
        url: String,
        method: HTTP.Method,
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        fileName: String?
    ) throws -> URLSession {
        let url = try XCTUnwrap(URL(string: url))
        return try Self.mockedSession(
            url: url,
            method: method,
            statusCode: statusCode,
            headers: headers,
            fileName: fileName
        )
    }

    static func mockedSession(
        url: URL,
        method: HTTP.Method,
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        fileName: String?
    ) throws -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, url)
            XCTAssertEqual(request.method, method)

            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headers))

            let data: Data?
            if let fileName {
                data = try XCTUnwrap(Helper.dataFromFile(named: fileName))
            } else {
                data = nil
            }

            return (response, data)
        }

        return urlSession
    }

    static func mockedSession(
        url: String,
        method: HTTP.Method,
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        rawResponse: String
    ) throws -> URLSession {
        let url = try XCTUnwrap(URL(string: url))
        return try Self.mockedSession(
            url: url,
            method: method,
            statusCode: statusCode,
            headers: headers,
            rawResponse: rawResponse
        )
    }

    static func mockedSession(
        url: URL,
        method: HTTP.Method,
        statusCode: Int = 200,
        headers: [String: String]? = nil,
        rawResponse: String
    ) throws -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)

        MockURLProtocol.requestHandler = { request in
            let url = try XCTUnwrap(request.url)
            XCTAssertEqual(url, url)
            XCTAssertEqual(request.method, method)

            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headers))

            return (response, rawResponse.data(using: .utf8))
        }

        return urlSession
    }
}
