// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "OctoprintSwift",
    platforms: [.macOS(.v11), .iOS(.v13)],
    products: [.library(name: "OctoprintSwift", targets: ["OctoprintSwift"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "OctoprintSwift",
            dependencies: []),
        .testTarget(
            name: "OctoprintSwiftTests",
            dependencies: ["OctoprintSwift"]),
    ]
)
