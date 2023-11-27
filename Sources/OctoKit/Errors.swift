enum Error: Swift.Error {
    case invalidURL
    case invalidURLResponse(statusCode: Int, error: Any?)
}
