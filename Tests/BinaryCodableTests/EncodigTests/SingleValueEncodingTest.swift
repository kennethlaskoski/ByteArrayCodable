//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import XCTest
@testable import BinaryCodable

final class SingleValueEncodingTest: XCTestCase {
  var encoder: BinaryEncoder!
  var expected: [UInt8] = []

  override func setUp() {
    encoder = BinaryEncoder()
    expected = []
  }

  override func tearDown() {
    XCTAssertEqual(encoder.data, expected)
  }

  func testEmpty() {}

  func testNil() throws {
    let nilValue: Int? = nil
    XCTAssertThrowsError(try nilValue.encode(to: encoder))

    do {
      try nilValue.encode(to: encoder)
    } catch let error as EncodingError {
      if case let .invalidValue(value, context) = error {
        XCTAssert(value is UInt8?)
        XCTAssertNil(value as! UInt8?)
        XCTAssertEqual(context.codingPath.map(\.debugDescription), encoder.codingPath.map(\.debugDescription))
        XCTAssertEqual(context.debugDescription, "Encoding nil is not supported.")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testBool() throws {
    try true.encode(to: encoder)
    expected.append(1)

    try false.encode(to: encoder)
    expected.append(0)
  }

  func testString() throws {
    try "".encode(to: encoder)
    expected.append(0)

    try "Hello".encode(to: encoder)
    expected.append(contentsOf: [0x48,0x65,0x6c,0x6c,0x6f,0])

    try "你好".encode(to: encoder)
    expected.append(contentsOf: [0xe4,0xbd,0xa0,0xe5,0xa5,0xbd,0])
  }

  func testInt() throws {
    try 0.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])

    try 1.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])

    try (-1).encode(to: encoder)
    expected.append(contentsOf: [0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff])

    try Int.max.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff])

    try Int.min.encode(to: encoder)
    expected.append(contentsOf: [0x80,0,0,0,0,0,0,0])
  }

  func testDouble() throws {
    try Double.zero.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])

    try Double.pi.encode(to: encoder)
    expected.append(contentsOf: [0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18])

    try Double.ulpOfOne.encode(to: encoder)
    expected.append(contentsOf: [0x3c,0xb0,0,0,0,0,0,0])

    try Double.leastNonzeroMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])

    try Double.leastNormalMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0x10,0,0,0,0,0,0])

    try Double.greatestFiniteMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xef,0xff,0xff,0xff,0xff,0xff,0xff])

    try Double.infinity.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xf0,0,0,0,0,0,0])

    try Double.nan.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xf8,0,0,0,0,0,0])

    try Double.signalingNaN.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xf4,0,0,0,0,0,0])

    try 0.0.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])

    try (-0.0).encode(to: encoder)
    expected.append(contentsOf: [0x80,0,0,0,0,0,0,0])

    try 1.0.encode(to: encoder)
    expected.append(contentsOf: [0x3f,0xf0,0,0,0,0,0,0])

    try (-1.0).encode(to: encoder)
    expected.append(contentsOf: [0xbf,0xf0,0,0,0,0,0,0])

    try (1.0 + .ulpOfOne).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0xf0,0,0,0,0,0,1])

    try 2.0.encode(to: encoder)
    expected.append(contentsOf: [0x40,0,0,0,0,0,0,0])

    try (-2.0).encode(to: encoder)
    expected.append(contentsOf: [0xc0,0,0,0,0,0,0,0])

    try (1.0 / 3.0).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0xd5,0x55,0x55,0x55,0x55,0x55,0x55])
  }

  func testFloat() throws {
    try Float.zero.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0])

    try Float.pi.encode(to: encoder)
    expected.append(contentsOf: [0x40,0x49,0x0f,0xda])

    try Float.ulpOfOne.encode(to: encoder)
    expected.append(contentsOf: [0x34,0,0,0])

    try Float.leastNonzeroMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,1])

    try Float.leastNormalMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0x80,0,0])

    try Float.greatestFiniteMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0x7f,0xff,0xff])

    try Float.infinity.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0x80,0,0])

    try Float.nan.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xc0,0,0])

    try Float.signalingNaN.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xa0,0,0])

    try Float(0.0).encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0])

    try Float(-0.0).encode(to: encoder)
    expected.append(contentsOf: [0x80,0,0,0])

    try Float(1.0).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0x80,0,0])

    try Float(-1.0).encode(to: encoder)
    expected.append(contentsOf: [0xbf,0x80,0,0])

    try (Float(1.0) + .ulpOfOne).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0x80,0,1])

    try Float(2.0).encode(to: encoder)
    expected.append(contentsOf: [0x40,0,0,0])

    try Float(-2.0).encode(to: encoder)
    expected.append(contentsOf: [0xc0,0,0,0])

    try (Float(1.0) / Float(3.0)).encode(to: encoder)
    expected.append(contentsOf: [0x3e,0xaa,0xaa,0xab])
  }

  func testRawRepresentable() throws {
    enum SomeRawEnum: Int, Encodable {
      case x
      case y
    }

    try SomeRawEnum.x.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])

    try SomeRawEnum.y.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
  }

  func testCustom() throws {
    struct Custom: Encodable {
      let x = 0

      func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(x)
      }
    }

    let x = Custom()
    var container = encoder.singleValueContainer()
    try container.encode(x)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
  }
}
