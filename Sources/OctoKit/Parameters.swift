import Foundation

public enum SortDirection: String {
    case ascending = "asc"
    case descending = "desc"
}

public enum SortType: String {
    case created
    case updated
    case popularity
    case longRunning = "long-running"
}
