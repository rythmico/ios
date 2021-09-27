// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RythmicoDTOEncore",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "StudentDTOEncore", targets: ["StudentDTOEncore"]),
        .library(name: "TutorDTOEncore", targets: ["TutorDTOEncore"]),
        .library(name: "CoreDTOEncore", targets: ["CoreDTOEncore"]),
    ],
    targets: [
        .target(name: "StudentDTOEncore", dependencies: [
            .target(name: "CoreDTOEncore"),
            .product(name: "StudentDTO", package: "RythmicoDTO"),
        ]),

        .target(name: "TutorDTOEncore", dependencies: [
            .target(name: "CoreDTOEncore"),
            .product(name: "TutorDTO", package: "RythmicoDTO"),
        ]),

        .target(name: "CoreDTOEncore", dependencies: [
            .product(name: "CoreDTO", package: "RythmicoDTO"),
        ]),
        .testTarget(name: "CoreDTOEncoreTests", dependencies: ["CoreDTOEncore"]),
    ]
)

package.dependencies = [
    .package(url: "https://github.com/rythmico/RythmicoDTO", .branch("main")),
]
