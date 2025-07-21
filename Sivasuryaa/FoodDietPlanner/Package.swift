// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "FoodDietPlanner",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "FoodDietPlanner",
            targets: ["FoodDietPlanner"])
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        .executableTarget(
            name: "FoodDietPlanner",
            dependencies: []),
        .testTarget(
            name: "FoodDietPlannerTests",
            dependencies: ["FoodDietPlanner"]),
    ]
)
