// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AAngle",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .visionOS(.v1),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "AAngle",
            targets: ["AAngle"]
        ),
    ],
    targets: [
        .target(
            name: "AAngle"
        ),
        .testTarget(
            name: "AAngleTests",
            dependencies: ["AAngle"]
        ),
    ]
)
