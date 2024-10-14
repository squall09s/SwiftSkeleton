// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSkeleton",
    platforms: [
        .macOS(.v13) // Définit la version minimale de macOS à 13.0
    ],
    products: [
        .executable(name: "SwiftSkeleton", targets: ["SwiftSkeleton"]),
    ],
    targets: [
            .executableTarget(
                name: "SwiftSkeleton",
                dependencies: [],
                resources: [
                        .process("Ressources/")
                ]
            ),
    ]
)
