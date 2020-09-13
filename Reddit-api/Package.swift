// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Reddit-api",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Reddit-api",
            targets: ["Reddit-api"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../Base"),
        .package(path: "../Endpoints")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Reddit-api",
            dependencies: ["Base", "Endpoints"]),
        .testTarget(
            name: "Reddit-apiTests",
//            resources: [ .process("stub-Listing<Reddit>.json") ],//TODO: add tool version 5.3
            dependencies: ["Reddit-api"]),
    ]
)