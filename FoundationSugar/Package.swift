// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoundationSugar",
    products: [
        .library(
            name: "FoundationSugar",
            targets: ["FoundationSugar"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/devxoul/Then", from: "2.7.0"),
    ],
    targets: [
        .target(
            name: "FoundationSugar",
            dependencies: ["Then"]
        ),
        .testTarget(
            name: "FoundationSugarTests",
            dependencies: ["FoundationSugar"]
        ),
    ]
)
