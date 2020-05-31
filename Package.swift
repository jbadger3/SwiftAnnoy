// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftAnnoy",
    products: [
        .library(
            name: "SwiftAnnoy",
            targets: ["SwiftAnnoy", "CAnnoyWrapper"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CAnnoyWrapper",
            dependencies: [],
            path: "./Sources/CAnnoyWrapper"),
        .target(
            name: "SwiftAnnoy",
            dependencies: ["CAnnoyWrapper"]),
        .testTarget(
            name: "SwiftAnnoyTests",
            dependencies: ["SwiftAnnoy"]),
    ]
)

