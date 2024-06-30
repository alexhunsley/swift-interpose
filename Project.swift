import ProjectDescription

let project = Project(
    name: "SwiftInterpose",
    targets: [
        .target(
            name: "SwiftInterpose",
            destinations: .macOS,
            product: .staticLibrary,
            bundleId: "io.hunsley.SwiftInterpose",
            sources: ["Sources/**"],
            dependencies: []
        ),
        .target(
            name: "SwiftInterposeTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.hunsley.SwiftInterposeTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "SwiftInterpose")]
        ),
    ]
)
