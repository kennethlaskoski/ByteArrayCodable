//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public class BinaryEncoder: Encoder {
  private var buffer: Code = []
  public var data: Code { buffer }

  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

  public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() -> UnkeyedEncodingContainer {
    fatalError("Unkeyed container not implemented.")
  }

  public func singleValueContainer() -> SingleValueEncodingContainer {
    self
  }
}

extension BinaryEncoder: SingleValueEncodingContainer {
  public func encodeNil() {
    buffer.append(0x3F)
    buffer.append(0x21)
    buffer.append(0xFF)
  }

  public func encode(_ value: Bool) {
    buffer.append(value ? 1 : 0)
  }

  public func encode(_ value: String) {
    value.utf8CString.forEach { encode($0) }
  }

  public func encode(_ value: Double) {
    encode(value.bitPattern)
  }

  public func encode(_ value: Float) {
    encode(value.bitPattern)
  }

  public func encode<T>(_ value: T) where T: Encodable, T: FixedWidthInteger {
    withUnsafeBytes(of: value.bigEndian) {
      buffer.append(contentsOf: $0)
    }
  }

  public func encode<T>(_ value: T) throws where T : Encodable {
    try value.encode(to: self)
  }
}
