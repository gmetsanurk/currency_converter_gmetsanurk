// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkManager",
    platforms: [
        .iOS(.v13)
    ],
    
    products: [
        .library(
            name: "NetworkManager",
            targets: ["NetworkManager"]),
    ],
    
    dependencies: [
            .package(url: "https://github.com/Moya/Moya", from: "15.0.0")
    ],
    
    targets: [
        .target(
            name: "NetworkManager",
            dependencies: [
                .product(name: "CombineMoya", package: "Moya")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
