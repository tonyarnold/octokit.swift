import Foundation

extension URLSession {
    func json<Content: Codable>(for request: URLRequest, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) async throws -> Content {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return try await json(for: request, decoder: decoder)
    }

    func json<Content: Codable>(for request: URLRequest, decoder: JSONDecoder = JSONDecoder()) async throws -> Content {
        let (data, response) = try await data(for: request)

        // Unwrap any non-successful responses into a proper error
        if let response = response as? HTTPURLResponse, response.wasSuccessful == false {
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                throw APIRequestRouterError.unsuccessfulRequest(statusCode: response.statusCode, underlyingError: .dictionary(json))
            } else if data.isEmpty == false, let string = String(data: data, encoding: .utf8) {
                throw APIRequestRouterError.unsuccessfulRequest(statusCode: response.statusCode, underlyingError: .string(string))
            } else {
                throw APIRequestRouterError.unsuccessfulRequest(statusCode: response.statusCode, underlyingError: .empty)
            }
        }

        return try decoder.decode(Content.self, from: data)
    }

    func sendRequest(for request: URLRequest) async throws {
        let (data, response) = try await data(for: request)

        // Unwrap any non-successful responses into a proper error
        if let response = response as? HTTPURLResponse, response.wasSuccessful == false {
            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                throw APIRequestRouterError.unsuccessfulRequest(statusCode: response.statusCode, underlyingError: .dictionary(json))
            } else if let string = String(data: data, encoding: .utf8) {
                throw APIRequestRouterError.unsuccessfulRequest(statusCode: response.statusCode, underlyingError: .string(string))
            } else {
                throw APIRequestRouterError.unsuccessfulRequest(statusCode: response.statusCode, underlyingError: .empty)
            }
        }
    }
}
