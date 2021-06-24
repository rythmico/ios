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
        .package(name: "ISO8601PeriodDuration", url: "https://github.com/treatwell/ISO8601PeriodDuration", from: "3.1.0"),
        .package(name: "PreciseDecimal", url: "https://github.com/davdroman/PreciseDecimal", from: "1.0.0"),
        .package(name: "swift-nonempty", url: "https://github.com/pointfreeco/swift-nonempty", from: "0.3.1"),
        .package(name: "swift-tagged", url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0"),
        .package(name: "Then", url: "https://github.com/devxoul/Then", from: "2.7.0"),
    ],
    targets: [
        .target(
            name: "FoundationSugar",
            dependencies: [
                .product(name: "ISO8601PeriodDuration", package: "ISO8601PeriodDuration"),
                .product(name: "NonEmpty", package: "swift-nonempty"),
                .product(name: "PreciseDecimal", package: "PreciseDecimal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Then", package: "Then"),
            ]
        ),
        .testTarget(
            name: "FoundationSugarTests",
            dependencies: ["FoundationSugar"]
        ),
    ]
)
