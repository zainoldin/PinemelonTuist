import ProjectDescription

let schemes = AppScheme.allCases.map { $0.getScheme(for: "Pinemelon") }

let settings = Settings.settings(base: ["MARKETING_VERSION": "2.0.0"],
                                 configurations: AppConfiguration.allCases.map { $0.configuration() })

let project = Project(
    name: "Pinemelon",
    organizationName: "Pinemelon Inc.",
    settings: settings,
    targets: [
        Target(
            name: "Pinemelon",
            platform: .iOS,
            product: .app,
            bundleId: "tuist.pinemelon.test.production",
            deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
            infoPlist: "Info.plist",
            sources: ["Sources/**"],
            resources: [
                "Resources/**",
                "Sources/**/*.xib",
                "Sources/**/*.storyboard"
            ],
            dependencies: [.project(target: "MelonKit", path: .relativeToManifest("../MelonKit"))],
            settings: settings
        )
    ],
    schemes: schemes
)

enum AppScheme: CaseIterable {
    case staging
    case production
    
    func getScheme(for target: String) -> Scheme {
        Scheme(name: getName(for: target),
               shared: true,
               buildAction: .init(targets: ["\(target)"]),
               runAction: .runAction(configuration: configurations.debug.name),
               archiveAction: .archiveAction(configuration: configurations.release.name),
               profileAction: .profileAction(configuration: configurations.release.name),
               analyzeAction: .analyzeAction(configuration: configurations.debug.name))
    }
}

private extension AppScheme {
    func getName(for target: String) -> String {
        switch self {
        case .staging:
            return "\(target)(Staging)"
        case .production:
            return "\(target)(Production)"
        }
    }
    
    var configurations: (debug: AppConfiguration, release: AppConfiguration) {
        switch self {
        case .staging:
            return (.debugStaging, .releaseStaging)
        case .production:
            return (.debugProduction, .releaseProduction)
        }
    }
}

enum AppConfiguration: CaseIterable {
    case debugStaging
    case debugProduction
    case releaseStaging
    case releaseProduction
    
    var name: ConfigurationName {
        switch self {
        case .debugStaging:
            return .init(stringLiteral: "Debug(Staging)")
        case .debugProduction:
            return .init(stringLiteral: "Debug(Production)")
        case .releaseStaging:
            return .init(stringLiteral: "Release(Staging)")
        case .releaseProduction:
            return .init(stringLiteral: "Release(Production)")
        }
    }
}


extension AppConfiguration {
    func configuration() -> Configuration {
        switch self {
        case .debugStaging, .debugProduction:
            return .debug(name: name,
                          settings: settings(displayName: "Pinemelon",
                                             targetName: "Pinemelon",
                                             bundleId: "tuist.pinemelon.test",
                                             developmentTeam: "1231244"))
        case .releaseStaging, .releaseProduction:
            return .release(name: name,
                            settings: settings(displayName: "Pinemelon",
                                               targetName: "Pinemelon",
                                               bundleId: "tuist.pinemelon.test",
                                               developmentTeam: "1231244"))
        }
    }

    private func settings(displayName: String,
                          targetName: String,
                          bundleId: String,
                          developmentTeam: SettingValue) -> [String: SettingValue]
    {
        [
            "APP_BUNDLE_NAME": "\(targetName)",
            "APP_DISPLAY_NAME": appName(targetName: displayName),
            "APP_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: bundleIdentifier(baseBundleId: bundleId)),
            "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: bundleIdentifier(baseBundleId: bundleId)),
            "DEVELOPMENT_TEAM": developmentTeam,
            "CODE_SIGN_STYLE": "Manual",
            "PROVISIONING_PROFILE_SPECIFIER": provisioningProfile(bundleId: bundleId),
            "CODE_SIGN_IDENTITY": codeSignIdentity(),
            "OTHER_LDFLAGS": "-ObjC -weak_framework SwiftUI -weak_framework Combine -lc++ -lstdc++ -lz -weak_framework Accelerate $(inherited)",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": compilationCondition()
        ]
    }

    private func appName(targetName: String) -> SettingValue {
        switch self {
        case .debugStaging, .releaseStaging:
            return "\(targetName) Staging"
        case .debugProduction, .releaseProduction:
            return "\(targetName)"
        }
    }

    private func provisioningProfile(bundleId: String) -> SettingValue {
        switch self {
        case .debugStaging, .debugProduction:
            return "match Development \(bundleIdentifier(baseBundleId: bundleId))"
        case .releaseStaging:
            return "match AdHoc \(bundleIdentifier(baseBundleId: bundleId))"
        case .releaseProduction:
            return "match AppStore \(bundleIdentifier(baseBundleId: bundleId))"
        }
    }

    private func codeSignIdentity() -> SettingValue {
        switch self {
        case .debugStaging, .debugProduction:
            return "iPhone Developer"
        case .releaseStaging, .releaseProduction:
            return "iPhone Distribution"
        }
    }

    private func bundleIdentifier(baseBundleId: String) -> String {
        switch self {
        case .debugStaging, .releaseStaging:
            return "\(baseBundleId).staging"
        case .debugProduction, .releaseProduction:
            return "\(baseBundleId).production"
        }
    }
    
    private func compilationCondition() -> SettingValue {
        switch self {
        case .debugStaging, .releaseStaging:
            return "STAGING"
        case .debugProduction, .releaseProduction:
            return "PRODUCTION"
        }
    }
}
