// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RapidoReach",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "RapidoReach",
            type: .dynamic,
            targets: ["RapidoReach"])
    ],
    targets: [
        .target(
            name: "RapidoReach",
            path: "Sources/RapidoReach",
            resources: [],
            swiftSettings: [
                .define("SWIFT_PACKAGE")
            ])
    ]
)
