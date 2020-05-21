// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OptionalAPI",
    products: [
        .library(
            name: "OptionalAPI",
            type: .dynamic,
            targets: ["OptionalAPI"]),
    ],
    dependencies: [],
    targets: [

        .target(
            name: "OptionalAPI",
            dependencies: []),
        .testTarget(
            name: "OptionalAPITests",
            dependencies: ["OptionalAPI"]),
    ]
)
