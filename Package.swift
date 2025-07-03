// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Monarca",
	platforms: [
		.iOS(.v13),
		.macOS(.v13)
	],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Monarca",
            targets: ["Monarca"]),
    ],
	dependencies: [
		.package(url: "https://github.com/vapor/websocket-kit.git", from: "2.16.0"),
	],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Monarca",
			dependencies: [
				.product(name: "WebSocketKit", package: "websocket-kit")
			]
		),
        .testTarget(
            name: "MonarcaTests",
            dependencies: ["Monarca"]
        ),
    ]
)
