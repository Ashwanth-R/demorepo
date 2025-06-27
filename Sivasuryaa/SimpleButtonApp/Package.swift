// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SimpleButtonApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "SimpleButtonApp", targets: ["SimpleButtonApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SimpleButtonApp",
            path: "."
        )
    ]
)
