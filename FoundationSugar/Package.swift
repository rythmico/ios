// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoundationSugar",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "FoundationSugar",
            targets: ["FoundationSugar"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/treatwell/ISO8601PeriodDuration", from: "3.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-nonempty", from: "0.3.1"),
        .package(url: "https://github.com/davdroman/PreciseDecimal", from: "1.0.0"),
        .package(url: "https://github.com/devxoul/Then", from: "2.7.0"),
    ],
    targets: [
        .target(
            name: "FoundationSugar",
            dependencies: [
                "ISO8601PeriodDuration",
                .product(name: "NonEmpty", package: "swift-nonempty"),
                "PreciseDecimal",
                "Then",
            ]
        ),
        .testTarget(
            name: "FoundationSugarTests",
            dependencies: ["FoundationSugar"]
        ),
    ]
)
