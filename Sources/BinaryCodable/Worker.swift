//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

struct Worker {
  private var buffer: [UInt8] = []
  var data: [UInt8] { buffer }

  func encodeNil() throws {
    throw EncodingError.invalidValue(
      Any.self,
      .init(
        codingPath: [],
        debugDescription: "Sorry, this encoder does not encode nil"
      )
    )
  }

  mutating func encode(_ value: Bool) {
    buffer.append(value ? 1 : 0)
  }

  mutating func encode<T>(_ value: T) where T: Encodable, T: FixedWidthInteger {
    withUnsafeBytes(of: value.bigEndian) {
      buffer.append(contentsOf: $0)
    }
  }

  mutating func encode(_ value: String) {
    value.utf8CString.forEach { encode($0) }
  }

  mutating func encode(_ value: Double) {
    encode(value.bitPattern)
  }

  mutating func encode(_ value: Float) {
    encode(value.bitPattern)
  }
}
