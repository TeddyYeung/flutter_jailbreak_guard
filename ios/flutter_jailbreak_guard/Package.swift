// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "flutter_jailbreak_guard",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "flutter-jailbreak-guard", targets: ["flutter_jailbreak_guard"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/securing/IOSSecuritySuite.git", "1.9.10"..<"3.0.0")
    ],
    targets: [
        .target(
            name: "flutter_jailbreak_guard",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "IOSSecuritySuite", package: "IOSSecuritySuite")
            ]
        )
    ]
)
