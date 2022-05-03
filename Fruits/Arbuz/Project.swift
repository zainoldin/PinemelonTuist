import ProjectDescription

let project = Project(
    name: "Arbuz",
    organizationName: "Arbuz Group TOO",
    targets: [
        Target(
            name: "Arbuz",
            platform: .iOS,
            product: .app,
            bundleId: "tuist.arbuz.test.production",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
            infoPlist: "Info.plist",
            sources: ["Sources/**"],
            resources: [
                "Resources/**",
                "Sources/**/*.xib",
                "Sources/**/*.storyboard"
            ],
            dependencies: [.project(target: "MelonKit", path: .relativeToManifest("../MelonKit"))]
        )
    ]
)
