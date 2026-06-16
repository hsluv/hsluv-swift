// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "HSLuvSwift",
    products: [
        .library(name: "HSLuv", targets: ["HSLuv"])
    ],
    targets: [
        .target(name: "HSLuv", path: "Sources"),
        .testTarget(
            name: "HSLuvTests",
            dependencies: ["HSLuv"],
            path: "Tests",
            resources: [.copy("Resources/snapshot-rev4.json")],
            swiftSettings: [.define("SPM")]
        )
    ]
)
