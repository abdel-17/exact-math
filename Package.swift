// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "exact-math",
    products: [
        .library(
            name: "RationalModule",
            targets: ["RationalModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics",
                 from: "1.0.0")
    ],
    targets: [
        .target(
            name: "RationalModule",
            dependencies: [
                .product(name: "RealModule",
                         package: "swift-numerics")
            ]),
        .testTarget(
            name: "RationalModuleTests",
            dependencies: ["RationalModule"]),
    ]
)
