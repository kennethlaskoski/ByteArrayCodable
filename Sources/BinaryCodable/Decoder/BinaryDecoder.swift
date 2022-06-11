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
