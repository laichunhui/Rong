// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rong",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        /// Features
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "Home", targets: ["Home"]),
        .library(name: "Chart", targets: ["Chart"]),
        .library(name: "Chat", targets: ["Chat"]),
        .library(name: "Setting", targets: ["Setting"]),
        
        /// Clients
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "AuthenticationClient", targets: ["AuthenticationClient"]),
        .library(name: "DatabaseClient", targets: ["DatabaseClient"]),
        .library(name: "DownloaderClient", targets: ["DownloaderClient"]),
        .library(name: "FileClient", targets: ["FileClient"]),
        .library(name: "ImageDatabaseCleint", targets: ["ImageDatabaseClient"]),
        .library(name: "VideoPlayerClient", targets: ["VideoPlayerClient"]),
        .library(name: "UserDefaultsClient", targets: ["UserDefaultsClient"]),
        /// Other
        .library(name: "AnyPublisherStream", targets: ["AnyPublisherStream"]),
        .library(name: "SharedModels", targets: ["SharedModels"]),
        .library(name: "Utilities", targets: ["Utilities"]),
        .library(name: "ViewComponents", targets: ["ViewComponents"]),
        .library(name: "Build", targets: ["Build"]),
        .library(name: "Logger", targets: ["Logger"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.5.5"),
//        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay.git", exact: "0.8.1"),
//        .package(url: "https://github.com/thisIsTheFoxe/SwiftWebVTT.git", exact: "0.1.0"),!
        .package(url: "https://github.com/NicholasBellucci/SociableWeaver.git", exact: "0.1.12"),
        .package(url: "https://github.com/apple/swift-collections.git", exact: "1.0.3"),
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", exact: "0.15.0"),
//        .package(url: "https://github.com/LiveUI/Awesome", exact: "2.4.0"),
        .package(url: "https://github.com/Cindori/FluidGradient.git", exact: "1.0.0"),
        .package(url: "https://github.com/johnpatrickmorgan/TCACoordinators.git", exact: "0.8.0"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "4.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        
        /// Features
        .target(
        name: "AppFeature",
        dependencies: [
            "Home",
            "Chart",
            "Chat",
            "Setting",
            "DatabaseClient",
            "DownloaderClient",
            "FileClient",
            "SharedModels",
            "UserDefaultsClient",
            "Utilities",
            "VideoPlayerClient",
            "ViewComponents",
            .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
        ]
    ),
        .target(
            name: "Home",
            dependencies: [
                "DatabaseClient",
                "DownloaderClient",
                "Logger",
                "SharedModels",
                "UserDefaultsClient",
                "Utilities",
                "ViewComponents",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "TCACoordinators", package: "TCACoordinators"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "Chart",
            dependencies: [
                "DatabaseClient",
                "SharedModels",
                "Utilities",
                "ViewComponents",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "TCACoordinators", package: "TCACoordinators"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "Chat",
            dependencies: [
                "DatabaseClient",
                "SharedModels",
                "Utilities",
                "ViewComponents",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "TCACoordinators", package: "TCACoordinators"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        .target(
            name: "Setting",
            dependencies: [
                "DatabaseClient",
                "SharedModels",
                "Utilities",
                "ViewComponents",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "TCACoordinators", package: "TCACoordinators"),
                .product(name: "SFSafeSymbols", package: "SFSafeSymbols")
            ]
        ),
        
        /// Clients
        .target(
            name: "APIClient",
            dependencies: [
                "AuthenticationClient",
                "Build",
                "Logger",
                "SharedModels",
                "Utilities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SociableWeaver", package: "SociableWeaver")
            ]
        ),
        .target(
            name: "AuthenticationClient",
            dependencies: [
                "Logger",
                "Utilities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "DatabaseClient",
            dependencies: [
                "Utilities",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "OrderedCollections", package: "swift-collections")
            ]
//            resources: [
//                .copy("Resources/Rong.xcdatamodeld")
//            ]
        ),
        .target(
            name: "Build",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "DownloaderClient",
            dependencies: [
                "Logger",
                "Utilities",
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "FileClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "ImageDatabaseClient"
        ),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                "SharedModels",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "VideoPlayerClient",
            dependencies: [
                "AnyPublisherStream",
                "SharedModels",
                "Utilities",
                "Logger",
                "ImageDatabaseClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "XMLCoder", package: "XMLCoder")
            ]
        ),

        /// Other
        .target(
            name: "SharedModels",
            dependencies: [
                "Utilities",
                .product(name: "SociableWeaver", package: "SociableWeaver")
            ]
        ),
        .target(
            name: "Utilities",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "OrderedCollections", package: "swift-collections")
            ]
        ),
        .target(
            name: "ViewComponents",
            dependencies: [
                "DownloaderClient",
                "SharedModels",
                "Utilities",
                "ImageDatabaseClient",
                .product(name: "FluidGradient", package: "FluidGradient")
            ]
        ),
        .target(name: "AnyPublisherStream"),
        .target(name: "Logger"),

        /// Test Targets
        .testTarget(
            name: "PackagesTests",
            dependencies: ["APIClient"]),
    ]
)
