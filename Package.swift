// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyEuroCardManager",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EasyEuroCardManager",
            targets: ["EasyEuroCardManager"]),
        .library(
            name: "EasyEuroCardManagerStub",
            targets: ["EasyEuroCardManagerStub"]),
    ],
    dependencies: [
        .package(url: "https://github.com/checkout/CheckoutCardManagement-iOS",from: "2.0.0"),
        .package(url: "https://github.com/checkout/NetworkClient-iOS",from: "1.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EasyEuroCardManager",
            dependencies: [
                .product(name: "CheckoutCardManagement",
                        package: "CheckoutCardManagement-iOS"),
                .product(name: "CheckoutNetwork",
                        package: "NetworkClient-iOS"),
                .product(name: "CheckoutOOBSDK",
                        package: "CheckoutCardManagement-iOS"),
            ]),
        .target(
            name: "EasyEuroCardManagerStub",
            dependencies: [
                .product(name: "CheckoutCardManagementStub",
                        package: "CheckoutCardManagement-iOS"),
                .product(name: "CheckoutNetwork",
                        package: "NetworkClient-iOS"),
                .product(name: "CheckoutOOBSDK",
                        package: "CheckoutCardManagement-iOS"),
            ]),
        .testTarget(
            name: "EasyEuroCardManagerTests",
            dependencies: ["EasyEuroCardManager"]),
    ]
)
