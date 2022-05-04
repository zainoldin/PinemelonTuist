import ProjectDescription

public enum AppConfiguration: CaseIterable {
    case debugStaging
    case debugProduction
    case releaseStaging
    case releaseProduction
    
    public func configuration(app: MelonApp) -> Configuration {
        switch self {
        case .debugStaging, .debugProduction:
            return .debug(name: name, settings: buildSettings(for: app))
        case .releaseStaging, .releaseProduction:
            return .release(name: name, settings: buildSettings(for: app))
        }
    }
    
    public var name: ConfigurationName {
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
    
    private func buildSettings(for app: MelonApp) -> [String: SettingValue] {
        [
            "APP_BUNDLE_NAME": "\(app.rawValue)",
            "APP_DISPLAY_NAME": appName(for: app.displayName),
            "APP_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: bundleIdentifier(baseBundleId: app.baseBundleId)),
            "PRODUCT_BUNDLE_IDENTIFIER": SettingValue(stringLiteral: bundleIdentifier(baseBundleId: app.baseBundleId)),
            "DEVELOPMENT_TEAM": app.developmentTeam,
            "CODE_SIGN_STYLE": "Manual",
            "PROVISIONING_PROFILE_SPECIFIER": provisioningProfile(baseBundleId: app.baseBundleId),
            "CODE_SIGN_IDENTITY": codeSignIdentity(),
            "OTHER_LDFLAGS": "-ObjC -weak_framework SwiftUI -weak_framework Combine -lc++ -lstdc++ -lz -weak_framework Accelerate $(inherited)",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": compilationCondition()
        ]
    }
}
        
private extension AppConfiguration {
    func appName(for targetName: String) -> SettingValue {
        switch self {
        case .debugStaging, .releaseStaging:
            return "\(targetName) Staging"
        case .debugProduction, .releaseProduction:
            return "\(targetName)"
        }
    }
    
    private func provisioningProfile(baseBundleId: String) -> SettingValue {
        switch self {
        case .debugStaging, .debugProduction:
            return "match Development \(bundleIdentifier(baseBundleId: baseBundleId))"
        case .releaseStaging:
            return "match AdHoc \(bundleIdentifier(baseBundleId: baseBundleId))"
        case .releaseProduction:
            return "match AppStore \(bundleIdentifier(baseBundleId: baseBundleId))"
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
    
    private func codeSignIdentity() -> SettingValue {
        switch self {
        case .debugStaging, .debugProduction:
            return "iPhone Developer"
        case .releaseStaging, .releaseProduction:
            return "iPhone Distribution"
        }
    }
}
