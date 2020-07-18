// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OptionalAPI",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "OptionalAPI",
            type: .dynamic,
            targets: ["OptionalAPI"]),
    ],
    dependencies: [
        .package(name: "SnapshotTesting",
                 url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
                 from: "1.7.2"),

        .package(
            name: "Prelude",
            url: "https://github.com/pointfreeco/swift-prelude.git", .branch("master")
        )
    ],
    targets: [
        .target(
            name: "OptionalAPI",
            dependencies: []),
        
        .testTarget(
            name: "OptionalAPITests",
            dependencies: [
                "OptionalAPI",
                "SnapshotTesting",
                "Prelude"
        ]),
    ]
)
