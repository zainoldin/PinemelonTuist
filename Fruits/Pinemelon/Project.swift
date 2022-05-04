import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(app: .Pinemelon, dependencies: [.project(target: "MelonKit", path: .relativeToManifest("../MelonKit"))])
