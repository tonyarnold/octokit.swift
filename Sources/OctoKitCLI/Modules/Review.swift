import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Review: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Reviews",
        subcommands: [
            GetList.self
        ]
    )
}

extension Review {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The number of the pull request")
        var number: Int

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let reviews = try await octokit.listReviews(owner: owner, repository: repository, pullRequestNumber: number)
            if let string = try prettyPrinted(reviews) {
                print(string.blue)
            }
        }
    }
}
