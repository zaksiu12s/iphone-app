// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Hello",
    platforms: [
        .iOS("27.0")
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
