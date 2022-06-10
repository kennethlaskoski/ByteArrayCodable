//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public class BinaryDecoder: Decoder {
  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

//  private var containers: [ContainerType] = []

  public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    fatalError("Unkeyed container not implemented.")
  }

  public func singleValueContainer() throws -> SingleValueDecodingContainer {
    fatalError("Single value container not implemented.")
  }

}
