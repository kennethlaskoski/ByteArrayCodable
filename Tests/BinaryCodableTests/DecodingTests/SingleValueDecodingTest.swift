//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import XCTest
@testable import BinaryCodable

final class SingleValueDecodingTest: XCTestCase {
  func testNil() throws {
    let decoder = BinaryDecoder(data: [])
    XCTAssertFalse(try decoder.singleValueContainer().decodeNil())
  }

  func testBool() throws {
    let decoder = BinaryDecoder(data: [1,0])
    XCTAssert(try Bool(from: decoder))
    XCTAssertFalse(try Bool(from: decoder))
  }

  func testString() throws {
    let decoder = BinaryDecoder(data: [
      0,
      0x48,0x65,0x6c,0x6c,0x6f,0,
      0xe4,0xbd,0xa0,0xe5,0xa5,0xbd,0,
    ])
    XCTAssertEqual(try String(from: decoder), "")
    XCTAssertEqual(try String(from: decoder), "Hello")
    XCTAssertEqual(try String(from: decoder), "你好")
  }

  func testInt() throws {
    let decoder = BinaryDecoder(data: [
      0x80,0,0,0,0,0,0,0,
      0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
      0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
      0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
    ])
    XCTAssertEqual(try Int(from: decoder), Int.min)
    XCTAssertEqual(try Int(from: decoder), -1)
    XCTAssertEqual(try Int(from: decoder), 0)
    XCTAssertEqual(try Int(from: decoder), 1)
    XCTAssertEqual(try Int(from: decoder), Int.max)
  }

  func testDouble() throws {
    let decoder = BinaryDecoder(data: [
      0,0,0,0,0,0,0,0,
      0x7f,0xf8,0,0,0,0,0,0,
      0x7f,0xf4,0,0,0,0,0,0,
      0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18,
      0x3c,0xb0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
      0,0x10,0,0,0,0,0,0,
      0x7f,0xef,0xff,0xff,0xff,0xff,0xff,0xff,
      0x7f,0xf0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,
      0x80,0,0,0,0,0,0,0,
      0x3f,0xf0,0,0,0,0,0,0,
      0xbf,0xf0,0,0,0,0,0,0,
      0x3f,0xf0,0,0,0,0,0,1,
      0x40,0,0,0,0,0,0,0,
      0xc0,0,0,0,0,0,0,0,
      0x3f,0xd5,0x55,0x55,0x55,0x55,0x55,0x55,
    ])
    XCTAssert(try Double(from: decoder).isZero)
    XCTAssert(try Double(from: decoder).isNaN)
    XCTAssert(try Double(from: decoder).isSignalingNaN)
    XCTAssertEqual(try Double(from: decoder), Double.pi)
    XCTAssertEqual(try Double(from: decoder), Double.ulpOfOne)
    XCTAssertEqual(try Double(from: decoder), Double.leastNonzeroMagnitude)
    XCTAssertEqual(try Double(from: decoder), Double.leastNormalMagnitude)
    XCTAssertEqual(try Double(from: decoder), Double.greatestFiniteMagnitude)
    XCTAssertEqual(try Double(from: decoder), Double.infinity)
    XCTAssertEqual(try Double(from: decoder), 0.0)
    XCTAssertEqual(try Double(from: decoder), (-0.0))
    XCTAssertEqual(try Double(from: decoder), 1.0)
    XCTAssertEqual(try Double(from: decoder), (-1.0))
    XCTAssertEqual(try Double(from: decoder), (1.0 + .ulpOfOne))
    XCTAssertEqual(try Double(from: decoder), 2.0)
    XCTAssertEqual(try Double(from: decoder), (-2.0))
    XCTAssertEqual(try Double(from: decoder), (1.0 / 3.0))
  }

  func testFloat() throws {
    let decoder = BinaryDecoder(data: [
      0,0,0,0,
      0x7f,0xc0,0,0,
      0x7f,0xa0,0,0,
      0x40,0x49,0x0f,0xda,
      0x34,0,0,0,
      0,0,0,1,
      0,0x80,0,0,
      0x7f,0x7f,0xff,0xff,
      0x7f,0x80,0,0,
      0,0,0,0,
      0x80,0,0,0,
      0x3f,0x80,0,0,
      0xbf,0x80,0,0,
      0x3f,0x80,0,1,
      0x40,0,0,0,
      0xc0,0,0,0,
      0x3e,0xaa,0xaa,0xab,
    ])
    XCTAssert(try Float(from: decoder).isZero)
    XCTAssert(try Float(from: decoder).isNaN)
    XCTAssert(try Float(from: decoder).isSignalingNaN)
    XCTAssertEqual(try Float(from: decoder), Float.pi)
    XCTAssertEqual(try Float(from: decoder), Float.ulpOfOne)
    XCTAssertEqual(try Float(from: decoder), Float.leastNonzeroMagnitude)
    XCTAssertEqual(try Float(from: decoder), Float.leastNormalMagnitude)
    XCTAssertEqual(try Float(from: decoder), Float.greatestFiniteMagnitude)
    XCTAssertEqual(try Float(from: decoder), Float.infinity)
    XCTAssertEqual(try Float(from: decoder), 0.0)
    XCTAssertEqual(try Float(from: decoder), (-0.0))
    XCTAssertEqual(try Float(from: decoder), 1.0)
    XCTAssertEqual(try Float(from: decoder), (-1.0))
    XCTAssertEqual(try Float(from: decoder), (1.0 + .ulpOfOne))
    XCTAssertEqual(try Float(from: decoder), 2.0)
    XCTAssertEqual(try Float(from: decoder), (-2.0))
    XCTAssertEqual(try Float(from: decoder), (1.0 / 3.0))
  }

//  func testRawRepresentable() throws {
//    enum SomeRawEnum: Int, Encodable {
//      case x
//      case y
//    }
//
//    try SomeRawEnum.x.encode(to: decoder)
//    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
//
//    try SomeRawEnum.y.encode(to: decoder)
//    expected.append(contentsOf: [0,0,0,0,0,0,0,1])
//  }
//
//  func testCustom() throws {
//    struct Custom: Encodable {
//      let x = 0
//
//      func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(x)
//      }
//    }
//
//    let x = Custom()
//    var container = decoder.singleValueContainer()
//    try container.encode(x)
//    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
//  }
}
