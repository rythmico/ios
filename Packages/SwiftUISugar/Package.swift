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
        .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect", from: "0.1.0"),
        .package(name: "MultiModal", url: "https://github.com/davdroman/MultiModal", from: "2.0.0"),
        .package(name: "SFSafeSymbols", url: "https://github.com/piknotech/SFSafeSymbols", from: "2.1.2"),
        .package(name: "WebView", url: "https://github.com/kylehickinson/SwiftUI-WebView", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "SwiftUISugar",
            dependencies: [
                .product(name: "Introspect", package: "Introspect"),
                .product(name: "MultiModal", package: "MultiModal"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols"),
                .product(name: "WebView", package: "WebView"),
            ]
        ),
        .testTarget(
            name: "SwiftUISugarTests",
            dependencies: ["SwiftUISugar"]
        ),
    ]
)
