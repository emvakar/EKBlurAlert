// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EKBlurAlert",
    platforms: [.iOS(.v10), .tvOS(.v10)],
    products: [
        .library(name: "EKBlurAlert", targets: ["EKBlurAlert"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.1"),
    ],
    targets: [
        .target(name: "EKBlurAlert", dependencies: ["SnapKit"]),
        .testTarget(name: "EKBlurAlertTests", dependencies: ["EKBlurAlert"]),
    ]
)
