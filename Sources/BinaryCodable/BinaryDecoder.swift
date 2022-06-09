//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public class BinaryDecoder: Decoder {
  private var buffer: Code = []
  public var data: Code { buffer }

  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

  public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() -> UnkeyedDecodingContainer {
    fatalError("Unkeyed container not implemented.")
  }

  public func singleValueContainer() -> SingleValueDecodingContainer {
    self
  }
}

extension BinaryDecoder: SingleValueDecodingContainer {
  public func decodeNil() -> Bool {
    false
  }

  public func decode(_ type: Bool.Type) throws -> Bool {
    fatalError("Not implemented.")
  }

  public func decode(_ type: String.Type) throws -> String {
    fatalError("Not implemented.")
  }

  public func decode(_ type: Double.Type) throws -> Double {
    fatalError("Not implemented.")
  }

  public func decode(_ type: Float.Type) throws -> Float {
    fatalError("Not implemented.")
  }

  public func decode(_ type: Int.Type) throws -> Int {
    fatalError("Not implemented.")
  }

  public func decode(_ type: Int8.Type) throws -> Int8 {
    fatalError("Not implemented.")
  }

  public func decode(_ type: Int16.Type) throws -> Int16 {
    fatalError("Not implemented.")
  }

  public func decode(_ type: Int32.Type) throws -> Int32 {
    fatalError("Not implemented.")
  }

  public func decode(_ type: Int64.Type) throws -> Int64 {
    fatalError("Not implemented.")
  }

  public func decode(_ type: UInt.Type) throws -> UInt {
    fatalError("Not implemented.")
  }

  public func decode(_ type: UInt8.Type) throws -> UInt8 {
    fatalError("Not implemented.")
  }

  public func decode(_ type: UInt16.Type) throws -> UInt16 {
    fatalError("Not implemented.")
  }

  public func decode(_ type: UInt32.Type) throws -> UInt32 {
    fatalError("Not implemented.")
  }

  public func decode(_ type: UInt64.Type) throws -> UInt64 {
    fatalError("Not implemented.")
  }

  public func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
    try .init(from: self)
  }
}
