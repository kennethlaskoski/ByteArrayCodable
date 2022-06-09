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

  func testNil() throws {
    let null: Int? = nil
    try encoder.encode(null)
    expected.append(contentsOf: [0x3f,0x21,0xff])
    XCTAssertEqual(encoder.data, expected)
  }

  func testNilMethod() throws {
    let null: Int? = nil
    try null.encode(to: encoder)
    expected.append(contentsOf: [0x3f,0x21,0xff])
    XCTAssertEqual(encoder.data, expected)
  }

  func testBool() throws {
    encoder.encode(true)
    expected.append(1)
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(false)
    expected.append(0)
    XCTAssertEqual(encoder.data, expected)
  }

  func testBoolMethod() throws {
    try true.encode(to: encoder)
    expected.append(1)
    XCTAssertEqual(encoder.data, expected)

    try false.encode(to: encoder)
    expected.append(0)
    XCTAssertEqual(encoder.data, expected)
  }

  func testString() throws {
    encoder.encode("")
    expected.append(0)
    XCTAssertEqual(encoder.data, expected)

    encoder.encode("Hello")
    expected.append(contentsOf: [0x48,0x65,0x6c,0x6c,0x6f,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode("你好")
    expected.append(contentsOf: [0xe4,0xbd,0xa0,0xe5,0xa5,0xbd,0])
    XCTAssertEqual(encoder.data, expected)
  }

  func testStringMethod() throws {
    try "".encode(to: encoder)
    expected.append(0)
    XCTAssertEqual(encoder.data, expected)

    try "Hello".encode(to: encoder)
    expected.append(contentsOf: [0x48,0x65,0x6c,0x6c,0x6f,0])
    XCTAssertEqual(encoder.data, expected)

    try "你好".encode(to: encoder)
    expected.append(contentsOf: [0xe4,0xbd,0xa0,0xe5,0xa5,0xbd,0])
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
    expected.append(contentsOf: [0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Int.max)
    expected.append(contentsOf: [0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Int.min)
    expected.append(contentsOf: [0x80,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)
  }

  func testIntMethod() throws {
    try 0.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try 1.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    try (-1).encode(to: encoder)
    expected.append(contentsOf: [0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    try Int.max.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    try Int.min.encode(to: encoder)
    expected.append(contentsOf: [0x80,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)
  }

  func testDouble() throws {
    encoder.encode(Double.zero)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.pi)
    expected.append(contentsOf: [0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.ulpOfOne)
    expected.append(contentsOf: [0x3c,0xb0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.leastNonzeroMagnitude)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.leastNormalMagnitude)
    expected.append(contentsOf: [0,0x10,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.greatestFiniteMagnitude)
    expected.append(contentsOf: [0x7f,0xef,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.infinity)
    expected.append(contentsOf: [0x7f,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.nan)
    expected.append(contentsOf: [0x7f,0xf8,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Double.signalingNaN)
    expected.append(contentsOf: [0x7f,0xf4,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(0.0)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(-0.0)
    expected.append(contentsOf: [0x80,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(1.0)
    expected.append(contentsOf: [0x3f,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(-1.0)
    expected.append(contentsOf: [0xbf,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(1.0 + .ulpOfOne)
    expected.append(contentsOf: [0x3f,0xf0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(2.0)
    expected.append(contentsOf: [0x40,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(-2.0)
    expected.append(contentsOf: [0xc0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(1.0 / 3.0)
    expected.append(contentsOf: [0x3f,0xd5,0x55,0x55,0x55,0x55,0x55,0x55])
    XCTAssertEqual(encoder.data, expected)
  }

  func testDoubleMethod() throws {
    try Double.zero.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Double.pi.encode(to: encoder)
    expected.append(contentsOf: [0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18])
    XCTAssertEqual(encoder.data, expected)

    try Double.ulpOfOne.encode(to: encoder)
    expected.append(contentsOf: [0x3c,0xb0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Double.leastNonzeroMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    try Double.leastNormalMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0x10,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Double.greatestFiniteMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xef,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    try Double.infinity.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Double.nan.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xf8,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Double.signalingNaN.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xf4,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try 0.0.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try (-0.0).encode(to: encoder)
    expected.append(contentsOf: [0x80,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try 1.0.encode(to: encoder)
    expected.append(contentsOf: [0x3f,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try (-1.0).encode(to: encoder)
    expected.append(contentsOf: [0xbf,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try (1.0 + .ulpOfOne).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0xf0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    try 2.0.encode(to: encoder)
    expected.append(contentsOf: [0x40,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try (-2.0).encode(to: encoder)
    expected.append(contentsOf: [0xc0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try (1.0 / 3.0).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0xd5,0x55,0x55,0x55,0x55,0x55,0x55])
    XCTAssertEqual(encoder.data, expected)
  }

  func testFloat() throws {
    encoder.encode(Float.zero)
    expected.append(contentsOf: [0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.pi)
    expected.append(contentsOf: [0x40,0x49,0x0f,0xda])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.ulpOfOne)
    expected.append(contentsOf: [0x34,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.leastNonzeroMagnitude)
    expected.append(contentsOf: [0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.leastNormalMagnitude)
    expected.append(contentsOf: [0,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.greatestFiniteMagnitude)
    expected.append(contentsOf: [0x7f,0x7f,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.infinity)
    expected.append(contentsOf: [0x7f,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.nan)
    expected.append(contentsOf: [0x7f,0xc0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float.signalingNaN)
    expected.append(contentsOf: [0x7f,0xa0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(0.0))
    expected.append(contentsOf: [0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(-0.0))
    expected.append(contentsOf: [0x80,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(1.0))
    expected.append(contentsOf: [0x3f,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(-1.0))
    expected.append(contentsOf: [0xbf,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(1.0) + .ulpOfOne)
    expected.append(contentsOf: [0x3f,0x80,0,1])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(2.0))
    expected.append(contentsOf: [0x40,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(-2.0))
    expected.append(contentsOf: [0xc0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    encoder.encode(Float(1.0) / Float(3.0))
    expected.append(contentsOf: [0x3e,0xaa,0xaa,0xab])
    XCTAssertEqual(encoder.data, expected)
  }

  func testFloatMethod() throws {
    try Float.zero.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float.pi.encode(to: encoder)
    expected.append(contentsOf: [0x40,0x49,0x0f,0xda])
    XCTAssertEqual(encoder.data, expected)

    try Float.ulpOfOne.encode(to: encoder)
    expected.append(contentsOf: [0x34,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float.leastNonzeroMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,1])
    XCTAssertEqual(encoder.data, expected)

    try Float.leastNormalMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float.greatestFiniteMagnitude.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0x7f,0xff,0xff])
    XCTAssertEqual(encoder.data, expected)

    try Float.infinity.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float.nan.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xc0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float.signalingNaN.encode(to: encoder)
    expected.append(contentsOf: [0x7f,0xa0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float(0.0).encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float(-0.0).encode(to: encoder)
    expected.append(contentsOf: [0x80,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float(1.0).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float(-1.0).encode(to: encoder)
    expected.append(contentsOf: [0xbf,0x80,0,0])
    XCTAssertEqual(encoder.data, expected)

    try (Float(1.0) + .ulpOfOne).encode(to: encoder)
    expected.append(contentsOf: [0x3f,0x80,0,1])
    XCTAssertEqual(encoder.data, expected)

    try Float(2.0).encode(to: encoder)
    expected.append(contentsOf: [0x40,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try Float(-2.0).encode(to: encoder)
    expected.append(contentsOf: [0xc0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try (Float(1.0) / Float(3.0)).encode(to: encoder)
    expected.append(contentsOf: [0x3e,0xaa,0xaa,0xab])
    XCTAssertEqual(encoder.data, expected)
  }

  func testRawRepresentable() throws {
    enum SomeRawEnum: Int, Encodable {
      case x
      case y
    }

    try encoder.encode(SomeRawEnum.x)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try encoder.encode(SomeRawEnum.y)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)
  }

  func testRawRepresentableMethod() throws {
    enum SomeRawEnum: Int, Encodable {
      case x
      case y
    }

    try SomeRawEnum.x.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
    XCTAssertEqual(encoder.data, expected)

    try SomeRawEnum.y.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
    XCTAssertEqual(encoder.data, expected)
  }

//  func testsEnum throws {
//    enum SomeEnum: Codable {
//      case x
//      case y
//    }
//
//    try encoder.encode(someEnum.x)
//  }

//  func testStruct() throws {
//    struct SomeStruct: Encodable {
//      let x = 0
//      let y = 1
//    }
//    let someStruct = SomeStruct()
//
//    XCTExpectFailure()
//    try encoder.encode(someStruct)
//    expected.append(contentsOf: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1])
//    XCTAssertEqual(encoder.data, expected)
//  }
}
