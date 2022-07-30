// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OptionalAPI",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v14),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "OptionalAPI",
            type: .dynamic,
            targets: ["OptionalAPI"]
        ),
    ],

    dependencies: [
        .package(
          url: "https://github.com/pointfreeco/swift-snapshot-testing.git",
          from: "1.9.0"
        ),

        .package(
            url: "https://github.com/pointfreeco/swift-prelude.git",
            branch: "main"
        ),
    ],

    targets: [
        .target(
            name: "OptionalAPI",
            dependencies: []
        ),
        
        .testTarget(
            name: "OptionalAPITests",
            dependencies: [
                "OptionalAPI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                .product(name: "Prelude", package: "swift-prelude"),
            ]
        ),
    ]
)
