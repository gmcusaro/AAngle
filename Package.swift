// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AAngle",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .visionOS(.v2),
        .watchOS(.v10),
        .tvOS(.v17)
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
