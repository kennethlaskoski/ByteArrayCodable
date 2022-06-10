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

  func testNonEmpty() throws {
    try [.min,-1,0,1,.max].encode(to: encoder)
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,5,
      0x80,0,0,0,0,0,0,
      0,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,
      0x7f,0xff,0xff,0xff,0xff,0xff,0xff,0xff
    ])
  }
}
