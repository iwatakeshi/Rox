// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Rox",
    targets: [
      Target(
        name: "Rox",
        dependencies: ["Core"]
     ),
      Target(name: "Core")
    ]
)
