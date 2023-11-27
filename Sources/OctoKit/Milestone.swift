import Foundation

open class Milestone: Codable {
    // MARK: Open

    open var url: URL?
    open var htmlURL: URL?
    open var labelsURL: URL?
    open private(set) var id: Int
    open var number: Int?
    open var state: State?
    open var title: String?
    open var milestoneDescription: String?
    open var creator: User?
    open var openIssues: Int?
    open var closedIssues: Int?
    open var createdAt: Date?
    open var updatedAt: Date?
    open var closedAt: Date?
    open var dueOn: Date?

    // MARK: Public

    public enum State: String, Codable {
        case open
        case closed
        case all
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case htmlURL = "html_url"
        case labelsURL = "labels_url"
        case number
        case state
        case title
        case milestoneDescription = "description"
        case creator
        case openIssues = "open_issues"
        case closedIssues = "closed_issues"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case dueOn = "due_on"
    }
}
