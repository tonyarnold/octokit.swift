import ArgumentParser
import Foundation
import Rainbow

struct SortedJSONKeys: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Sorting Keys in JSON")

    @Argument(help: "The file path to sort the JSON Content")
    var filePaths: [String]

    mutating func run() async throws {
        for filePath in filePaths {
            let content = try String(contentsOfFile: filePath)
            let prettyString = content.prettyPrintedJSONString
            try prettyString?.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Formatted \(filePath)".green)
        }
    }
}
