// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "ByteArrayCodable",
  products: [
    .library(
      name: "ByteArrayCodable",
      targets: ["ByteArrayCodable"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "ByteArrayCodable",
      dependencies: []
    ),
    .testTarget(
      name: "ByteArrayCodableTests",
      dependencies: ["ByteArrayCodable"]
    ),
  ]
)
