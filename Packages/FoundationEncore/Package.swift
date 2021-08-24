// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoundationEncore",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "FoundationEncore", targets: ["FoundationEncore"]),
        .library(name: "AnyEquatable", targets: ["AnyEquatable"]),
    ],
    dependencies: [
        .package(name: "ISO8601PeriodDuration", url: "https://github.com/treatwell/ISO8601PeriodDuration", from: "3.1.0"),
        .package(name: "LegibleError", url: "https://github.com/mxcl/LegibleError", from: "1.0.5"),
        .package(name: "PreciseDecimal", url: "https://github.com/davdroman/PreciseDecimal", from: "1.0.0"),
        .package(name: "swift-algorithms", url: "https://github.com/apple/swift-algorithms", from: "0.2.1"),
        .package(name: "swift-nonempty", url: "https://github.com/pointfreeco/swift-nonempty", from: "0.3.1"),
        .package(name: "swift-tagged", url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0"),
        .package(name: "Then", url: "https://github.com/devxoul/Then", from: "2.7.0"),
        .package(name: "Version", url: "https://github.com/mxcl/Version", from: "2.0.1"),
    ],
    targets: [
        .target(
            name: "FoundationEncore",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .target(name: "AnyEquatable"),
                .product(name: "LegibleError", package: "LegibleError"),
                .product(name: "ISO8601PeriodDuration", package: "ISO8601PeriodDuration"),
                .product(name: "NonEmpty", package: "swift-nonempty"),
                .product(name: "PreciseDecimal", package: "PreciseDecimal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Then", package: "Then"),
                .product(name: "Version", package: "Version"),
            ]
        ),
        .testTarget(name: "FoundationEncoreTests", dependencies: ["FoundationEncore"]),

        .target(name: "AnyEquatable"),
        .testTarget(name: "AnyEquatableTests", dependencies: ["AnyEquatable"]),
    ]
)
