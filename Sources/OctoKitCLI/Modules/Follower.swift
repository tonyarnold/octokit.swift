import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Follower: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Followes",
        subcommands: [
            GetList.self
        ]
    )
}

extension Follower {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The name of the user")
        var name: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let followers = try await octokit.followers(name: name)

            if let string = try prettyPrinted(followers) {
                print(string.blue)
            }
        }
    }
}
