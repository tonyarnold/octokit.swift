import ArgumentParser
import Foundation
import OctoKit
import Rainbow

struct Release: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Operate on Releases",
        subcommands: [
//          Get.self,
            GetList.self
        ]
    )
}

extension Release {
//    struct Get: AsyncParsableCommand {
//        @Argument(help: "The owner of the repository")
//        var owner: String
//
//        @Argument(help: "The name of the repository")
//        var repository: String
//
//        @Argument(help: "The tag of the release")
//        var tag: String
//
//        @Flag(help: "Verbose output flag")
//        var verbose: Bool = false
//
//        mutating func run() async throws {
//            let octokit = Octokit()
//            let session = FixtureURLSession()
//            _ = try await octokit.release(session, owner: owner, repository: repository, tag: tag)
//            session.verbosePrint(verbose: verbose)
//            try session.printResponseToFileOrConsole(filePath: filePath)
//        }
//    }

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
            let releases = try await octokit.listReleases(owner: owner, repository: repository)
            if let string = try prettyPrinted(releases) {
                print(string.blue)
            }
        }
    }
}
