// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIEncore",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "SwiftUIEncore", targets: ["SwiftUIEncore"]),
        .library(name: "Container", targets: ["Container"]),
        .library(name: "CustomButton", targets: ["CustomButton"]),
        .library(name: "DebugModifiers", targets: ["DebugModifiers"]),
        .library(name: "Flow", targets: ["Flow"]),
        .library(name: "FocusState", targets: ["FocusState"]),
        .library(name: "PagingView", targets: ["PagingView"]),
    ],
    targets: [
        .target(name: "SwiftUIEncore", dependencies: [
            .target(name: "Container"),
            .target(name: "CustomButton"),
            .target(name: "DebugModifiers"),
            .target(name: "Flow"),
            .target(name: "FocusState"),
            .product(name: "FoundationEncore", package: "FoundationEncore"),
            .product(name: "Introspect", package: "Introspect"),
            .product(name: "MultiModal", package: "MultiModal"),
            .target(name: "PagingView"),
            .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
            .product(name: "TextBuilder", package: "TextBuilder"),
            .product(name: "WebView", package: "WebView"),
        ]),

        .target(name: "Container"),

        .target(name: "CustomButton"),

        .target(name: "DebugModifiers"),

        .target(name: "Flow"),

        .target(name: "FocusState"),

        .target(name: "PagingView"),
    ]
)

package.dependencies = [
    .package(path: "FoundationEncore"),
    .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect", from: "0.1.0"),
    .package(name: "MultiModal", url: "https://github.com/davdroman/MultiModal", from: "2.0.0"),
    .package(name: "SFSafeSymbols", url: "https://github.com/piknotech/SFSafeSymbols", from: "2.1.2"),
    .package(name: "TextBuilder", url: "https://github.com/davdroman/TextBuilder", from: "1.0.0"),
    .package(name: "WebView", url: "https://github.com/kylehickinson/SwiftUI-WebView", from: "0.3.0"),
]
