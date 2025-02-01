// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AAngle",
    products: [
        .library(
            name: "AAngle",
            targets: ["AAngle"]),
    ],
    targets: [
        .target(
            name: "AAngle"),
        .testTarget(
            name: "AAngleTests",
            dependencies: ["AAngle"]
        ),
    ]
)
