// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "DangerJazzy",
    products: [
        .library(name: "DangerJazzy", targets: ["DangerJazzy"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/danger-swift.git", from: "1.5.0"),
    ],
    targets: [
        .target(name: "DangerJazzy", dependencies: ["Danger"]),
        .testTarget(name: "DangerJazzyTests", dependencies: ["DangerJazzy", "DangerFixtures"]),
    ]
)
