import Foundation
import Rainbow

class URLSessionLoggingDelegate: NSObject, URLSessionDataDelegate {
    init(isVerbose: Bool = false) {
        self.isVerbose = isVerbose
    }

    var isVerbose: Bool

    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        guard isVerbose, let request = task.originalRequest else {
            return
        }

        guard let requestURL = request.url, let requestMethod = request.httpMethod else {
            print("No URL or HTTPMethod".red)
            return
        }

        print("\(requestMethod) \(requestURL)".yellow)
    }
}
