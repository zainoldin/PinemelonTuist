import ProjectDescription

public enum MelonApp: String {
    case Arbuz
    case Pinemelon
}

public extension MelonApp {
    var displayName: String {
        switch self {
        case .Arbuz:
            return "Arbuz.kz"
        case .Pinemelon:
            return "Pinemelon"
        }
    }
    
    var organizationName: String {
        switch self {
        case .Arbuz:
            return "Arbuz Group TOO"
        case .Pinemelon:
            return "Pinemelon.com Inc."
        }
    }
    
    var baseBundleId: String {
        switch self {
        case .Arbuz:
            return "tuist.arbuz.test"
        case .Pinemelon:
            return "tuist.pinemelon.test"
        }
    }
    
    var developmentTeam: SettingValue {
        switch self {
        case .Arbuz:
            return "TEST123456"
        case .Pinemelon:
            return "123456TEST"
        }
    }
    
    var version: SettingsDictionary {
        switch self {
        case .Arbuz:
            return ["MARKETING_VERSION": "1.0"].currentProjectVersion("2")
        case .Pinemelon:
            return ["MARKETING_VERSION": "1.0"].currentProjectVersion("3")
        }
    }
}
