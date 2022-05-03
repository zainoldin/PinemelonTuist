import ProjectDescription

let project = Project(
    name: "MelonKit",
    organizationName: "Pinemelon Inc.",
    targets: [
        Target(
            name: "MelonKit",
            platform: .iOS,
            product: .staticFramework,
            bundleId: "tuist.melonKit.test",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: [
                "Resources/**",
                "Sources/**/*.xib",
                "Sources/**/*.storyboard",
                .glob(pattern: "Sources/**/*.storyboard")
            ],
            dependencies: [],
            coreDataModels: [
                CoreDataModel("Sources/PinemelonTuist.xcdatamodeld")
            ]
        )
    ]
)
