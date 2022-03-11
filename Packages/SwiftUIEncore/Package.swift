// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIEncore",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "SwiftUIEncore", targets: ["SwiftUIEncore"]),
        .library(name: "Container", targets: ["Container"]),
        .library(name: "CustomButton", targets: ["CustomButton"]),
        .library(name: "DebugModifiers", targets: ["DebugModifiers"]),
        .library(name: "Flow", targets: ["Flow"]),
        .library(name: "FocusState", targets: ["FocusState"]),
        .library(name: "PagingView", targets: ["PagingView"]),
        .library(name: "StatefulView", targets: ["StatefulView"]),
    ],
    targets: [
        .target(name: "SwiftUIEncore", dependencies: [
            .target(name: "Container"),
            .target(name: "CustomButton"),
            .target(name: "DebugModifiers"),
            .target(name: "Flow"),
            .target(name: "FocusState"),
            .product(name: "FoundationEncore", package: "swift-foundation-encore"),
            .product(name: "Introspect", package: "SwiftUI-Introspect"),
            .product(name: "MultiModal", package: "MultiModal"),
            .target(name: "PagingView"),
            .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
            .target(name: "StatefulView"),
            .product(name: "TextBuilder", package: "TextBuilder"),
            .product(name: "WebView", package: "SwiftUI-WebView"),
        ]),

        .target(name: "Container"),

        .target(name: "CustomButton"),

        .target(name: "DebugModifiers"),

        .target(name: "Flow"),

        .target(name: "FocusState"),

        .target(name: "PagingView"),

        .target(name: "StatefulView"),
    ]
)

package.dependencies = [
    .package(url: "https://github.com/rythmico/swift-foundation-encore", branch: "main"),
    .package(url: "https://github.com/siteline/SwiftUI-Introspect", from: "0.1.0"),
    .package(url: "https://github.com/davdroman/MultiModal", from: "2.0.0"),
    .package(url: "https://github.com/piknotech/SFSafeSymbols", from: "2.1.2"),
    .package(url: "https://github.com/davdroman/TextBuilder", from: "1.0.0"),
    .package(url: "https://github.com/kylehickinson/SwiftUI-WebView", from: "0.3.0"),
]
