import Foundation

public typealias Files = [String: File]

open class File: Codable, Identifiable {
    // MARK: Open

    open private(set) var id: Int = -1
    open var rawURL: URL?
    open var filename: String?
    open var type: String?
    open var language: String?
    open var size: Int?
    open var content: String?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case rawURL = "raw_url"
        case filename
        case type
        case language
        case size
        case content
    }
}
