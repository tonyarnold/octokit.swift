import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Star: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Stars",
        subcommands: [
            GetList.self
        ]
    )
}

extension Star {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The user to fetch stars for")
        var name: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let stars = try await octokit.stars(name: name)
            if let string = try prettyPrinted(stars) {
                print(string.blue)
            }
        }
    }
}
