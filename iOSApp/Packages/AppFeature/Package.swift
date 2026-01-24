// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AppFeature",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "Entity", targets: ["Entity"]),
        .library(name: "AppExtension", targets: ["AppExtension"]),
        .library(name: "Infrastructure", targets: ["Infrastructure"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "Components", targets: ["Components"]),
        .library(name: "ViewStateProvider", targets: ["ViewStateProvider"]),
        .library(name: "Screen", targets: ["Screen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Nuke.git", from: "12.8.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "25.0.1"),
    ],
    targets: [
        .target(
            name: "Entity",
            dependencies: [],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "AppExtension",
            dependencies: [],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "Infrastructure",
            dependencies: ["Entity"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "Common",
            dependencies: ["AppExtension"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "Components",
            dependencies: [
                "AppExtension",
                .product(name: "Cosmos", package: "Cosmos"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "ViewStateProvider",
            dependencies: ["Entity", "Infrastructure"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "Screen",
            dependencies: [
                "Entity",
                "AppExtension",
                "Infrastructure",
                "Common",
                "Components",
                "ViewStateProvider",
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "NukeUI", package: "Nuke"),
            ],
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
