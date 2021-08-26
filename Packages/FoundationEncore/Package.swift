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
        .library(name: "Builders", targets: ["Builders"]),
        .library(name: "Do", targets: ["Do"]),
        .library(name: "EnumTag", targets: ["EnumTag"]),
        .library(name: "NilAssertingOperator", targets: ["NilAssertingOperator"]),
        .library(name: "OptionalProtocol", targets: ["OptionalProtocol"]),
        .library(name: "ResultProtocol", targets: ["ResultProtocol"]),
        .library(name: "UnwrapTuple", targets: ["UnwrapTuple"]),
    ],
    targets: [
        .target(name: "FoundationEncore", dependencies: [
            .product(name: "Algorithms", package: "swift-algorithms"),
            .target(name: "AnyEquatable"),
            .target(name: "Builders"),
            .target(name: "Do"),
            .target(name: "EnumTag"),
            .product(name: "ISO8601PeriodDuration", package: "ISO8601PeriodDuration"),
            .product(name: "LegibleError", package: "LegibleError"),
            .target(name: "NilAssertingOperator"),
            .product(name: "NonEmpty", package: "swift-nonempty"),
            .target(name: "OptionalProtocol"),
            .product(name: "PreciseDecimal", package: "PreciseDecimal"),
            .target(name: "ResultProtocol"),
            .product(name: "Tagged", package: "swift-tagged"),
            .target(name: "UnwrapTuple"),
            .product(name: "Version", package: "Version"),
        ]),
        .testTarget(name: "FoundationEncoreTests", dependencies: ["FoundationEncore"]),

        .target(name: "AnyEquatable"),
        .testTarget(name: "AnyEquatableTests", dependencies: ["AnyEquatable"]),

        .target(name: "Builders"),
        .testTarget(name: "BuildersTests", dependencies: ["Builders"]),

        .target(name: "Do", exclude: ["Do.swift.gyb"]),
        .testTarget(name: "DoTests", dependencies: ["Do"]),

        .target(name: "EnumTag"),

        .target(name: "NilAssertingOperator"),

        .target(name: "OptionalProtocol"),

        .target(name: "ResultProtocol"),

        .target(name: "UnwrapTuple"),
    ]
)

package.dependencies = [
    .package(name: "ISO8601PeriodDuration", url: "https://github.com/treatwell/ISO8601PeriodDuration", from: "3.1.0"),
    .package(name: "LegibleError", url: "https://github.com/mxcl/LegibleError", from: "1.0.5"),
    .package(name: "PreciseDecimal", url: "https://github.com/davdroman/PreciseDecimal", from: "1.0.0"),
    .package(name: "swift-algorithms", url: "https://github.com/apple/swift-algorithms", from: "0.2.1"),
    .package(name: "swift-nonempty", url: "https://github.com/pointfreeco/swift-nonempty", from: "0.3.1"),
    .package(name: "swift-tagged", url: "https://github.com/pointfreeco/swift-tagged", from: "0.6.0"),
    .package(name: "Version", url: "https://github.com/mxcl/Version", from: "2.0.1"),
]
