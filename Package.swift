// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "OctoKit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .macCatalyst(.v17)
    ],
    products: [
        .library(name: "OctoKit", targets: ["OctoKit"]),
        .executable(name: "octokit-cli", targets: ["OctoKitCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.3"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "OctoKit"
        ),
        .testTarget(
            name: "OctoKitTests",
            dependencies: [
                .target(name: "OctoKit")
            ],
            resources: [
                .copy("Fixtures")
            ]
        ),
        .executableTarget(
            name: "OctoKitCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Rainbow", package: "rainbow"),
                .target(name: "OctoKit")
            ]
        )
    ]
)
