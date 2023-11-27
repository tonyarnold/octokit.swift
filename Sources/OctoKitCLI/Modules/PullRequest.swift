import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct PullRequest: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on PullRequest",
        subcommands: [
            Get.self,
            GetList.self
        ]
    )
}

extension PullRequest {
    struct Get: AsyncParsableCommand {
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
            let pullRequest = try await octokit.pullRequest(owner: owner, repository: repository, number: number)
            if let string = try prettyPrinted(pullRequest) {
                print(string.blue)
            }
        }
    }

    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let pullRequests = try await octokit.pullRequests(owner: owner, repository: repository)
            if let string = try prettyPrinted(pullRequests) {
                print(string.blue)
            }
        }
    }
}
