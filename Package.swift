// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "BinaryCodec",
  products: [
    .library(
      name: "BinaryCodec",
      targets: ["BinaryCodec"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "BinaryCodec",
      dependencies: []
    ),
    .testTarget(
      name: "BinaryCodecTests",
      dependencies: ["BinaryCodec"]
    ),
  ]
)
