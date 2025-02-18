/// `Reactions` are available on all Issues and Pull Requests.
///
/// `Reactions` are in general available as an object in some API response,
/// there is no API available directly for `Reactions`.
public struct Reactions: Codable {
    // MARK: Lifecycle

    public init(
        totalCount: Int?,
        thumbsUp: Int?,
        thumbsDown: Int?,
        laugh: Int?,
        confused: Int?,
        heart: Int?,
        hooray: Int?,
        rocket: Int?,
        eyes: Int?,
        url: String?
    ) {
        self.totalCount = totalCount
        self.thumbsUp = thumbsUp
        self.thumbsDown = thumbsDown
        self.laugh = laugh
        self.confused = confused
        self.heart = heart
        self.hooray = hooray
        self.rocket = rocket
        self.eyes = eyes
        self.url = url
    }

    // MARK: Public

    public let totalCount: Int?
    public let thumbsUp: Int?
    public let thumbsDown: Int?
    public let laugh: Int?
    public let confused: Int?
    public let heart: Int?
    public let hooray: Int?
    public let rocket: Int?
    public let eyes: Int?
    public let url: String?

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case laugh
        case confused
        case heart
        case hooray
        case url
        case eyes
        case rocket
        case totalCount = "total_count"
        case thumbsUp = "+1"
        case thumbsDown = "-1"
    }
}
