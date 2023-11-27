import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Repository: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Repositories",
        subcommands: [
            Get.self,
            GetList.self
        ]
    )
}

extension Repository {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var name: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let repository = try await octokit.repository(owner: owner, name: name)
            if let string = try prettyPrinted(repository) {
                print(string.blue)
            }
        }
    }

    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let repositories = try await octokit.repositories(owner: owner)
            if let string = try prettyPrinted(repositories) {
                print(string.blue)
            }
        }
    }
}
