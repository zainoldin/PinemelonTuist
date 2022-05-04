import ProjectDescription

public enum AppScheme: CaseIterable {
    case staging
    case production

    public func getScheme(for target: String) -> Scheme {
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
    private func getName(for target: String) -> String {
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
