//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public class BinaryDecoder: Decoder {
  let buffer: [UInt8]
  var offset: Int = 0

  public init(data: [UInt8]) {
    buffer = data
  }

  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

  public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    fatalError("Unkeyed container not implemented.")
  }

  public func singleValueContainer() throws -> SingleValueDecodingContainer {
    let newContainer = SingleValueContainer(decoder: self)
    return newContainer
  }
}

extension BinaryDecoder {
  struct DecodingWorker {
    func decode(_ type: Bool.Type, cursor: UnsafeRawPointer)
    throws -> Bool
    {
      cursor.load(as: UInt8.self) == 1
    }

    func decode<T>(_ type: T.Type, cursor: UnsafeRawPointer)
    throws -> T
    where T: Decodable, T: FixedWidthInteger
    {
      T(bigEndian: cursor.load(as: T.self))
    }
  }
}
