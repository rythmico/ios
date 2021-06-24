// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUISugar",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftUISugar",
            targets: ["SwiftUISugar"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/piknotech/SFSafeSymbols", from: "2.1.2"),
    ],
    targets: [
        .target(
            name: "SwiftUISugar",
            dependencies: [
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
            ]
        ),
        .testTarget(
            name: "SwiftUISugarTests",
            dependencies: ["SwiftUISugar"]
        ),
    ]
)
