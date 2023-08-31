// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OptionalAPI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
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
          from: "1.12.0"
        ),
        .package(
            url: "https://github.com/sloik/AliasWonderland.git",
            from: "3.5.11" // use latest version instead
        )
    ],

    targets: [
        .target(
            name: "OptionalAPI",
            dependencies: [
                "AliasWonderland"
            ]
        ),
        
        .testTarget(
            name: "OptionalAPITests",
            dependencies: [
                "OptionalAPI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ]
)
