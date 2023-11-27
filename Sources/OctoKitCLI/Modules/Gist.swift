import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Gist: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Gists",
        subcommands: [
            Get.self,
            GetList.self
        ]
    )
}

extension Gist {
    struct Get: AsyncParsableCommand {
        init() {}

        @Argument(help: "The id of the gist")
        var id: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let gist = try await octokit.gist(id: id)

            if let string = try prettyPrinted(gist) {
                print(string.blue)
            }
        }
    }
}

extension Gist {
    struct GetList: AsyncParsableCommand {
        @Argument(help: "The owner of the gists")
        var owner: String

        @Flag(help: "Verbose output flag")
        var verbose = false

        mutating func run() async throws {
            let delegate = URLSessionLoggingDelegate(isVerbose: verbose)
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
            let octokit = Octokit(session: session)
            let gists = try await octokit.gists(owner: owner)

            if let string = try prettyPrinted(gists) {
                print(string.blue)
            }
        }
    }
}
