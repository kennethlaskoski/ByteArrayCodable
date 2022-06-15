//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import XCTest
@testable import ByteArrayCodable

final class UnkeyedEncodingTest: XCTestCase {
  let encoder = ByteArrayEncoder()

  func testEmpty() throws {
    let empty: [Int] = []
    XCTAssertEqual(try encoder.encode(empty), [0,0,0,0,0,0,0,0])
  }

  func testNil() throws {
    let nilArray: [Int]? = nil
    XCTAssertThrowsError(try encoder.encode(nilArray))

    let array: [Int?] = [nil, -1, 0, 1, nil]
    do {
      _ = try encoder.encode(array)
    } catch let error as EncodingError {
      if case let .invalidValue(value, context) = error {
        XCTAssert(value is UInt8?)
        XCTAssertNil(value as! UInt8?)
        XCTAssertEqual(context.codingPath.count, 0)
        XCTAssertEqual(context.debugDescription, "Encoding nil is not supported.")
        XCTAssertNil(context.underlyingError)
      }
    }

    XCTAssertEqual(
      try encoder.encode(array.filter { $0 != nil }),
      [
        0,0,0,0,0,0,0,3,
        0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,1,
      ]
    )
  }

  func testBool() throws {
    XCTAssertEqual(
      try encoder.encode([false,true]),
      [0,0,0,0,0,0,0,2,0,1]
    )
  }

  func testString() throws {
    XCTAssertEqual(
      try encoder.encode(["","Hello","你好"]),
      [
        0,0,0,0,0,0,0,3,
        0,
        0x48,0x65,0x6c,0x6c,0x6f,0,
        0xe4,0xbd,0xa0,0xe5,0xa5,0xbd,0,
      ]
    )
  }

  func testInt() throws {
   XCTAssertEqual(
     try encoder.encode([.min,-1,0,1,.max]),
     [
      0,0,0,0,0,0,0,5,
      0x80,0,0,0,0,0,0,0,
      0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
      0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
      0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
     ]
   )
  }

  func testDouble() throws {
    XCTAssertEqual(
      try encoder.encode(
        [
          Double.zero,
          Double.pi,
          Double.ulpOfOne,
          Double.leastNonzeroMagnitude,
          Double.leastNormalMagnitude,
          Double.greatestFiniteMagnitude,
          Double.infinity,
          -Double.infinity,
          Double.nan,
          Double.signalingNaN,
          0.0,
          (-0.0),
          1.0,
          (-1.0),
          (1.0 + .ulpOfOne),
          2.0,
          (-2.0),
          (1.0 / 3.0),
        ]
      ),
      [
        0,0,0,0,0,0,0,18,
        0,0,0,0,0,0,0,0,
        0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18,
        0x3c,0xb0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,1,
        0,0x10,0,0,0,0,0,0,
        0x7f,0xef,0xff,0xff,0xff,0xff,0xff,0xff,
        0x7f,0xf0,0,0,0,0,0,0,
        0xff,0xf0,0,0,0,0,0,0,
        0x7f,0xf8,0,0,0,0,0,0,
        0x7f,0xf4,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0x80,0,0,0,0,0,0,0,
        0x3f,0xf0,0,0,0,0,0,0,
        0xbf,0xf0,0,0,0,0,0,0,
        0x3f,0xf0,0,0,0,0,0,1,
        0x40,0,0,0,0,0,0,0,
        0xc0,0,0,0,0,0,0,0,
        0x3f,0xd5,0x55,0x55,0x55,0x55,0x55,0x55,
      ]
    )
  }

  func testFloat() throws {
    XCTAssertEqual(
      try encoder.encode(
        [
          Float.zero,
          Float.pi,
          Float.ulpOfOne,
          Float.leastNonzeroMagnitude,
          Float.leastNormalMagnitude,
          Float.greatestFiniteMagnitude,
          Float.infinity,
          -Float.infinity,
          Float.nan,
          Float.signalingNaN,
          Float(0.0),
          Float(-0.0),
          Float(1.0),
          Float(-1.0),
          Float(1.0) + .ulpOfOne,
          Float(2.0),
          Float(-2.0),
          Float(1.0) / Float(3.0),
        ]
      ),
      [
        0,0,0,0,0,0,0,18,
        0,0,0,0,
        0x40,0x49,0x0f,0xda,
        0x34,0,0,0,
        0,0,0,1,
        0,0x80,0,0,
        0x7f,0x7f,0xff,0xff,
        0x7f,0x80,0,0,
        0xff,0x80,0,0,
        0x7f,0xc0,0,0,
        0x7f,0xa0,0,0,
        0,0,0,0,
        0x80,0,0,0,
        0x3f,0x80,0,0,
        0xbf,0x80,0,0,
        0x3f,0x80,0,1,
        0x40,0,0,0,
        0xc0,0,0,0,
        0x3e,0xaa,0xaa,0xab,
      ]
    )
  }

  func testCustom() throws {
    struct Custom: Encodable {
      let x: [Int]? = nil

      func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encodeNil()
      }
    }

    XCTAssertThrowsError(try encoder.encode(Custom()))
  }
}
