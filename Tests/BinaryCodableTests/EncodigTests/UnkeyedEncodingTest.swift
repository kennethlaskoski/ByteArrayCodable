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
    XCTAssertEqual(encoder.data, expected)
  }

  func testEmpty() throws {
    let empty: [Int] = []
    try empty.encode(to: encoder)
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])
  }

  func testNil() throws {
    var container = encoder.unkeyedContainer()
    XCTAssertThrowsError(try container.encodeNil())
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])

    let array: [Int?] = [nil, -1, 0, 1, nil]
    XCTAssertThrowsError(try array.encode(to: encoder))
    expected.append(contentsOf: [0,0,0,0,0,0,0,0])

    try array.filter { $0 != nil }.encode(to: encoder)
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,3,
      0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
      0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
    ])

    let dropped = Array(array.dropFirst())
    XCTAssertThrowsError(try dropped.encode(to: encoder))
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,3,
      0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
      0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
    ])

    let null: [Int]? = nil
    XCTAssertThrowsError(try null.encode(to: encoder))
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

  func testDouble() throws {
    try [
      Double.zero,
      Double.pi,
      Double.ulpOfOne,
      Double.leastNonzeroMagnitude,
      Double.leastNormalMagnitude,
      Double.greatestFiniteMagnitude,
      Double.infinity,
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
    ].encode(to: encoder)
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,17,
      0,0,0,0,0,0,0,0,
      0x40,0x09,0x21,0xfb,0x54,0x44,0x2d,0x18,
      0x3c,0xb0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,1,
      0,0x10,0,0,0,0,0,0,
      0x7f,0xef,0xff,0xff,0xff,0xff,0xff,0xff,
      0x7f,0xf0,0,0,0,0,0,0,
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
    ])
  }

  func testFloat() throws {
    try [
      Float.zero,
      Float.pi,
      Float.ulpOfOne,
      Float.leastNonzeroMagnitude,
      Float.leastNormalMagnitude,
      Float.greatestFiniteMagnitude,
      Float.infinity,
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
    ].encode(to: encoder)
    expected.append(contentsOf: [
      0,0,0,0,0,0,0,17,
      0,0,0,0,
      0x40,0x49,0x0f,0xda,
      0x34,0,0,0,
      0,0,0,1,
      0,0x80,0,0,
      0x7f,0x7f,0xff,0xff,
      0x7f,0x80,0,0,
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
    ])
  }
}
