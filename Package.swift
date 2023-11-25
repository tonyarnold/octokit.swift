// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "OctoKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v8),
        .macCatalyst(.v16)
    ],
    products: [
        .library(name: "OctoKit", targets: ["OctoKit"]),
        .executable(name: "OctoKitCLI", targets: ["OctoKitCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/nerdishbynature/RequestKit.git", from: "3.2.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.52.10"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "OctoKit",
            dependencies: [
                .product(name: "RequestKit", package: "RequestKit")
            ]
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
