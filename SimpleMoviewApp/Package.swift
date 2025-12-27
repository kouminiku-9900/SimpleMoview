// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SimpleMoviewApp",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "SimpleMoviewApp", targets: ["SimpleMoviewApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SimpleMoviewApp",
            path: "Sources",
            linkerSettings: [
                .linkedFramework("AVKit")
            ]
        )
    ]
)
