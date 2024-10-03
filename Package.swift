// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-guitar-chords",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "GuitarChords",
            targets: ["GuitarChords"]
        ),
        .library(
            name: "GuitarChordPreviews",
            targets: ["GuitarChordPreviews"]
        ),
    ],
    dependencies: [
//        .package(url: "https://github.com/swiftlang/swift-format", branch: "main"),
    ],
    targets: [
        .target(
            name: "GuitarChords"
        ),
        .target(
            name: "GuitarChordPreviews",
            dependencies: ["GuitarChords"]
        ),
        .testTarget(
            name: "GuitarChordsTests",
            dependencies: ["GuitarChords"]
        ),
    ]
)
