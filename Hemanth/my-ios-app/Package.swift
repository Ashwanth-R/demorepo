// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "my-ios-app",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "my-ios-app",
            targets: ["App"]
        )
    ],
    dependencies: [
        // Add any dependencies your project requires here
    ],
    targets: [
        .target(
            name: "App",
            dependencies: []
        ),
        .testTarget(
            name: "ViewModelTests",
            dependencies: ["App"]
        )
    ]
)