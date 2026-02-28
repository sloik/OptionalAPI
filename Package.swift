// swift-tools-version:6.0

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
            targets: ["OptionalAPI"]
        ),
    ],

    dependencies: [
        .package(
            url: "https://github.com/sloik/AliasWonderland.git",
            from: "4.0.1" // use latest version instead
        )
    ],

    targets: [
        .target(
            name: "OptionalAPI",
            dependencies: [
                "AliasWonderland"
            ],
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
            ]
        ),

        .testTarget(
            name: "OptionalAPITests",
            dependencies: [
                "OptionalAPI",
            ]
        ),
    ]
)
