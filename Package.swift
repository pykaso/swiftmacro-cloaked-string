// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "CloakedStringMacro",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CloakedStringMacro",
            targets: ["CloakedStringMacro"]
        ),
        .executable(
            name: "CloakedStringMacroClient",
            targets: ["CloakedStringMacroClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "CloakedStringMacroMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "CloakedStringMacro", dependencies: ["CloakedStringMacroMacros"]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "CloakedStringMacroClient", dependencies: ["CloakedStringMacro"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "CloakedStringMacroTests",
            dependencies: [
                "CloakedStringMacroMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
