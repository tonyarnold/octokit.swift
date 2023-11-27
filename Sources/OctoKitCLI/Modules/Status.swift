import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Status: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Status",
        subcommands: [
            GetList.self
        ]
    )
}

extension Status {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The SHA, branch name or tag name")
        var reference: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let commitStatuses = try await octokit.listCommitStatuses(owner: owner, repository: repository, ref: reference)
            if let string = try prettyPrinted(commitStatuses) {
                print(string.blue)
            }
        }
    }
}
