import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Label: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Labels",
        subcommands: [
            Get.self,
            GetList.self
        ]
    )
}

extension Label {
    struct Get: AsyncParsableCommand {
        @Argument(help: "The owner of the repository")
        var owner: String

        @Argument(help: "The name of the repository")
        var repository: String

        @Argument(help: "The name of the label")
        var name: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let label = try await octokit.label(owner: owner, repository: repository, name: name)
            if let string = try prettyPrinted(label) {
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
            let labels = try await octokit.labels(owner: owner, repository: repository)
            if let string = try prettyPrinted(labels) {
                print(string.blue)
            }
        }
    }
}
