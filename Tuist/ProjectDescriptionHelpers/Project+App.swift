import ProjectDescription

public extension Project {
    static func app(app: MelonApp,
                    dependencies: [TargetDependency] = []) -> Project
    {
        let settingsConfigurations = AppConfiguration.allCases.map { $0.configuration(app: app)}
        let settings = Settings.settings(base: app.version, configurations: settingsConfigurations)
        let schemes = AppScheme.allCases.map { $0.getScheme(for: app.rawValue) }
        
        return Project(
            name: app.rawValue,
            organizationName: app.organizationName,
            settings: settings,
            targets: [
                Target(
                    name: app.rawValue,
                    platform: .iOS,
                    product: .app,
                    bundleId: app.baseBundleId,
                    deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
                    infoPlist: "Info.plist",
                    sources: ["Sources/**"],
                    resources: [
                        "Resources/**",
                        "Sources/**/*.xib",
                        "Sources/**/*.storyboard"
                    ],
                    dependencies: dependencies,
                    settings: settings
                )
            ],
            schemes: schemes
        )
    }
}

