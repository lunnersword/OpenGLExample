// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Dependencies",
    products: [
        .library(name: "Dependencies", type: .dynamic, targets: ["Dependencies"]),
    ],
    dependencies: [
        .package(url: "https://github.com/lunnersword/GLHelper", from: "0.1.2"),
    ],
    targets: [
        .target(name: "Dependencies", dependencies: ["GLHelper"], path: "." )
    ]
)
