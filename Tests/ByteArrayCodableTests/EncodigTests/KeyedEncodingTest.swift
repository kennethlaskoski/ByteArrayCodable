//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import XCTest
@testable import ByteArrayCodable

final class KeyedEncodingTest: XCTestCase {
  let encoder = ByteArrayEncoder()

  func testEmpty() throws {
    let empty: [Int: Int] = [:]
    XCTAssertEqual(try encoder.encode(empty), [0,0,0,0,0,0,0,0])
  }

  func testDictionary() throws {
    XCTAssertEqual(
      try encoder.encode(
        [
          2: false,
          7: true,
        ]
      ),
      [
        0,0,0,0,0,0,0,2,
        0x32,0,0,
        0x37,0,1,
      ]
    )
  }

  func testStruct() throws {
    struct EncodableStruct: Encodable {
      let int: Int = 0
      let double: Double = .pi
      let string: String = "Hello"
    }

    XCTAssertEqual(
      try encoder.encode(EncodableStruct()),
      [
        0,0,0,0,0,0,0,3,
        0x64,0x6f,0x75,0x62,0x6c,0x65,0,
        0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18,
        0x69,0x6e,0x74,0,
        0,0,0,0,0,0,0,0,
        0x73,0x74,0x72,0x69,0x6e,0x67,0,
        0x48,0x65,0x6c,0x6c,0x6f,0,
      ]
    )
  }
}
