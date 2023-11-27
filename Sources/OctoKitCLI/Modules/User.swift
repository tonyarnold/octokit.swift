import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct User: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Users",
        subcommands: [
            Get.self
        ]
    )
}

extension User {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The name of the user")
        var name: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let user = try await octokit.user(name: name)
            if let string = try prettyPrinted(user) {
                print(string.blue)
            }
        }
    }
}
