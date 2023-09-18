// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "OctoprintSwift",
    platforms: [.macOS(.v13), .iOS(.v13)],
    products: [.library(name: "OctoprintSwift", targets: ["OctoprintSwift"])],
    dependencies: [],
    targets: [
        .target(
            name: "OctoprintSwift",
            dependencies: []),
        .testTarget(
            name: "OctoprintSwiftTests",
            dependencies: ["OctoprintSwift"]),
    ]
)
