//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import XCTest
@testable import ByteArrayCodable

final class SingleValueEncodingTest: XCTestCase {
  let encoder = ByteArrayEncoder()

  func testNil() throws {
    let nilValue: Int? = nil
    XCTAssertThrowsError(try encoder.encode(nilValue))

    do {
      _ = try encoder.encode(nilValue)
    } catch let error as EncodingError {
      if case let .invalidValue(value, context) = error {
        XCTAssert(value is UInt8?)
        XCTAssertNil(value as! UInt8?)
        XCTAssertEqual(context.codingPath.count, 0)
        XCTAssertEqual(context.debugDescription, "Encoding nil is not supported.")
        XCTAssertNil(context.underlyingError)
      }
    }
  }

  func testBool() throws {
    XCTAssertEqual(try encoder.encode(true), [1])
    XCTAssertEqual(try encoder.encode(false), [0])
  }

  func testString() throws {
    XCTAssertEqual(try encoder.encode(""), [0])
    XCTAssertEqual(try encoder.encode("Hello"), [0x48,0x65,0x6c,0x6c,0x6f,0])
    XCTAssertEqual(try encoder.encode("你好"), [0xe4,0xbd,0xa0,0xe5,0xa5,0xbd,0])
  }

  func testInt() throws {
    XCTAssertEqual(try encoder.encode(0), [0,0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(1), [0,0,0,0,0,0,0,1])
    XCTAssertEqual(try encoder.encode(-1), [0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(try encoder.encode(Int.max), [0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(try encoder.encode(Int.min), [0x80,0,0,0,0,0,0,0])
  }

  func testDouble() throws {
    XCTAssertEqual(try encoder.encode(Double.zero), [0,0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(Double.pi), [0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18])
    XCTAssertEqual(try encoder.encode(Double.ulpOfOne), [0x3c,0xb0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(Double.leastNonzeroMagnitude), [0,0,0,0,0,0,0,1])
    XCTAssertEqual(try encoder.encode(Double.leastNormalMagnitude), [0,0x10,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(Double.greatestFiniteMagnitude), [0x7f,0xef,0xff,0xff,0xff,0xff,0xff,0xff])
    XCTAssertEqual(try encoder.encode(Double.infinity), [0x7f,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(-Double.infinity), [0xff,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(Double.nan), [0x7f,0xf8,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(Double.signalingNaN), [0x7f,0xf4,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(0.0), [0,0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(-0.0), [0x80,0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(1.0), [0x3f,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(-1.0), [0xbf,0xf0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(1.0 + .ulpOfOne), [0x3f,0xf0,0,0,0,0,0,1])
    XCTAssertEqual(try encoder.encode(2.0), [0x40,0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(-2.0), [0xc0,0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(1.0 / 3.0), [0x3f,0xd5,0x55,0x55,0x55,0x55,0x55,0x55])
  }

  func testFloat() throws {
    XCTAssertEqual(try encoder.encode(Float.zero), [0,0,0,0])
    XCTAssertEqual(try encoder.encode(Float.pi), [0x40,0x49,0x0f,0xda])
    XCTAssertEqual(try encoder.encode(Float.ulpOfOne), [0x34,0,0,0])
    XCTAssertEqual(try encoder.encode(Float.leastNonzeroMagnitude), [0,0,0,1])
    XCTAssertEqual(try encoder.encode(Float.leastNormalMagnitude), [0,0x80,0,0])
    XCTAssertEqual(try encoder.encode(Float.greatestFiniteMagnitude), [0x7f,0x7f,0xff,0xff])
    XCTAssertEqual(try encoder.encode(Float.infinity), [0x7f,0x80,0,0])
    XCTAssertEqual(try encoder.encode(-Float.infinity), [0xff,0x80,0,0])
    XCTAssertEqual(try encoder.encode(Float.nan), [0x7f,0xc0,0,0])
    XCTAssertEqual(try encoder.encode(Float.signalingNaN), [0x7f,0xa0,0,0])
    XCTAssertEqual(try encoder.encode(Float(0.0)), [0,0,0,0])
    XCTAssertEqual(try encoder.encode(Float(-0.0)), [0x80,0,0,0])
    XCTAssertEqual(try encoder.encode(Float(1.0)), [0x3f,0x80,0,0])
    XCTAssertEqual(try encoder.encode(Float(-1.0)), [0xbf,0x80,0,0])
    XCTAssertEqual(try encoder.encode(Float(1.0) + .ulpOfOne), [0x3f,0x80,0,1])
    XCTAssertEqual(try encoder.encode(Float(2.0)), [0x40,0,0,0])
    XCTAssertEqual(try encoder.encode(Float(-2.0)), [0xc0,0,0,0])
    XCTAssertEqual(try encoder.encode(Float(1.0) / Float(3.0)), [0x3e,0xaa,0xaa,0xab])
  }

  func testRawRepresentable() throws {
    enum RawEnum: Int, Encodable {
      case x
      case y
    }

    XCTAssertEqual(try encoder.encode(RawEnum.x), [0,0,0,0,0,0,0,0])
    XCTAssertEqual(try encoder.encode(RawEnum.y), [0,0,0,0,0,0,0,1])
  }

  func testCustom() throws {
    enum RawEnum: Int, Encodable {
      case x
      case y
    }

    struct Custom: Encodable {
      let x: RawEnum = .x

      func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(x)
      }
    }

    XCTAssertEqual(try encoder.encode(Custom()), [0,0,0,0,0,0,0,0])
  }
}
