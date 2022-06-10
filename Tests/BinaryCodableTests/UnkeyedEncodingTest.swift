//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import XCTest
@testable import BinaryCodable

final class UnkeyedEncodingTest: XCTestCase {
  var encoder: BinaryEncoder!
  var expected: [UInt8] = []

  override func setUp() {
    encoder = BinaryEncoder()
    expected = []
  }

  override func tearDown() {
    XCTAssertEqual(encoder.flatData, expected)
  }

  func testEmpty() throws {
    let empty: [Int] = []
    try empty.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
  }

  func testBool() throws {
    try [false,true].encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,2,0,1])
  }

  func testString() throws {
    try ["","Hello","你好"].encode(to: encoder)
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,3,
      0,
      0x48,0x65,0x6c,0x6c,0x6f,0,
      0xe4,0xbd,0xa0,0xe5,0xa5,0xbd,0,
    ])
  }

  func testOptional() throws {
    let array: [Int?] = [nil, -1, 0, 1, nil]
    try array.encode(to: encoder)
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,5,
      0x3f,0x21,0xff,
      0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
      0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
      0x3f,0x21,0xff,
    ])
  }

  func testInt() throws {
    try [.min,-1,0,1,.max].encode(to: encoder)
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,5,
      0x80,0,0,0,0,0,0,0,
      0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
      0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
      0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
    ])
  }
}
