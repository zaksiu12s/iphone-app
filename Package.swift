// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Hello",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "Hello",
            targets: ["Hello"]
        )
    ],
    targets: [
        .target(
            name: "Hello"
        )
    ]
)
