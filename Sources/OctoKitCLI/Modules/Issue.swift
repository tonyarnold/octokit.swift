import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Issue: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Issues",
        subcommands: [
            Get.self,
            GetList.self
        ]
    )
}

extension Issue {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The number of the issue")
        var number: Int

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let issue = try await octokit.issue(owner: owner, repository: repository, number: number)
            if let string = try prettyPrinted(issue) {
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
            let issues = try await octokit.issues(owner: owner, repository: repository)
            if let string = try prettyPrinted(issues) {
                print(string.blue)
            }
        }
    }
}
