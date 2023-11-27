import Foundation
import OctoKit

class Helper {
    class func dataFromFile(named name: String) throws -> Data? {
        guard let fileURL = jsonFileURL(for: name) else {
            return nil
        }

        return try Data(contentsOf: fileURL, options: .uncached)
    }

    class func stringFromFile(_ name: String) -> String? {
        let path = jsonFilePath(for: name)
        return try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
    }

    class func JSONFromFile(_ name: String) -> Any {
        let path = jsonFilePath(for: name)
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let dict: Any? = try? JSONSerialization.jsonObject(with: data,
                                                           options: JSONSerialization.ReadingOptions.mutableContainers)
        return dict!
    }

    class func codableFromFile<T>(_ name: String, type _: T.Type) -> T where T: Codable {
        let path = jsonFilePath(for: name)
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Time.rfc3339DateFormatter)
        return try! decoder.decode(T.self, from: data)
    }

    class func makeAuthHeader(username: String, password: String) -> [String: String] {
        let token = "\(username):\(password)".data(using: .utf8)!.base64EncodedString()
        return [
            "Authorization": "Basic \(token)"
        ]
    }

    private class func jsonFilePath(for resourceName: String) -> String {
        return Bundle.module.path(forResource: resourceName, ofType: "json", inDirectory: "Fixtures")!
    }

    private class func jsonFileURL(for resourceName: String) -> URL? {
        return Bundle.module.url(forResource: resourceName, withExtension: "json", subdirectory: "Fixtures")
    }
}
