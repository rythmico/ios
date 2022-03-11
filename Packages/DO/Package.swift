// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DO",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "StudentDO", targets: ["StudentDO"]),
        .library(name: "TutorDO", targets: ["TutorDO"]),
        .library(name: "CoreDO", targets: ["CoreDO"]),
    ],
    targets: [
        .target(name: "StudentDO", dependencies: [
            .target(name: "CoreDO"),
            .product(name: "StudentDTO", package: "dto-swift"),
        ]),

        .target(name: "TutorDO", dependencies: [
            .target(name: "CoreDO"),
            .product(name: "TutorDTO", package: "dto-swift"),
        ]),
        .testTarget(name: "TutorDOTests", dependencies: ["TutorDO"]),

        .target(name: "CoreDO", dependencies: [
            .product(name: "CoreDTO", package: "dto-swift"),
        ]),
        .testTarget(name: "CoreDOTests", dependencies: ["CoreDO"]),
    ]
)

package.dependencies = [
    .package(url: "https://github.com/rythmico/dto-swift", branch: "main"),
]
