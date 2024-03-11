// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
        .library(
            name: "Domain",
            targets: ["Domain"]),
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [.package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.9.2")],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Presentation",
            dependencies: [.product(name: "ComposableArchitecture", package: "swift-composable-architecture")],
            resources: [.process("Resources/Assets")]),
        .target(
            name: "Domain"),
        .target(
            name: "Data"),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]),
    ]
)
