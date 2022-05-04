import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(app: .Arbuz, dependencies: [.project(target: "MelonKit", path: .relativeToManifest("../MelonKit"))])
