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
        .library(name: "Repository", targets: ["Repository"]),
        .library(name: "UseCase", targets: ["UseCase"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "ViewStateProvider", targets: ["ViewStateProvider"]),
        .library(name: "Screen", targets: ["Screen"]),
    ],
    dependencies: [],
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
            name: "Repository",
            dependencies: ["Entity", "Infrastructure"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "UseCase",
            dependencies: ["Entity", "Repository"],
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
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "ViewStateProvider",
            dependencies: ["Entity", "Infrastructure", "Repository", "UseCase"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .target(
            name: "Screen",
            dependencies: [
                "Entity",
                "AppExtension",
                "Infrastructure",
                "Common",
                "ViewStateProvider",
            ],
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // MARK: - Test Targets
        .testTarget(
            name: "UseCaseTests",
            dependencies: ["UseCase", "Entity", "Repository"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository", "Entity", "Infrastructure"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
