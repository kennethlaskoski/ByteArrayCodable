//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import XCTest
@testable import BinaryCodable

final class BinaryEncoderTests: XCTestCase {
  var encoder: BinaryEncoder!
  var expected: Code = []

  override func setUp() {
    encoder = BinaryEncoder()
    expected = []
  }

  func testCreateEmpty() throws {
    XCTAssertEqual(encoder.data, expected)
  }

  func testInt() throws {
    encoder.encode(0)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(1)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(-1)
    expected.append(contentsOf: [255,255,255,255,255,255,255,255])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Int.max)
    expected.append(contentsOf: [127,255,255,255,255,255,255,255])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Int.min)
    expected.append(contentsOf: [128,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)
  }

  func testNativeInt() throws {
    try 0.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try 1.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    try (-1).encode(to: encoder)
    expected.append(contentsOf: [255,255,255,255,255,255,255,255])
    XCTAssertEqual(encoder.data, expected)

    try Int.max.encode(to: encoder)
    expected.append(contentsOf: [127,255,255,255,255,255,255,255])
    XCTAssertEqual(encoder.data, expected)

    try Int.min.encode(to: encoder)
    expected.append(contentsOf: [128,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)
  }
}
