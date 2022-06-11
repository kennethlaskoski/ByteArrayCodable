//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public final class BinaryEncoder: Encoder {
  private var containers: [EncodingContainer] = []

  public var data: [UInt8] {
    containers.flatMap { $0.data }
  }

  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

  public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() -> UnkeyedEncodingContainer {
    let newContainer = UnkeyedContainer(encoder: self)
    containers.append(newContainer)
    return newContainer
  }

  public func singleValueContainer() -> SingleValueEncodingContainer {
    let newContainer = SingleValueContainer(encoder: self)
    containers.append(newContainer)
    return newContainer
  }
}

protocol EncodingContainer {
  var data: [UInt8] { get }
}

extension BinaryEncoder {
  struct Worker {
    func encode(_ value: Bool) -> [UInt8] {
      [value ? 1 : 0]
    }

    func encode<T>(_ value: T) -> [UInt8]
    where T: Encodable, T: FixedWidthInteger
    {
      withUnsafeBytes(of: value.bigEndian) { $0.map { $0 } }
    }

    func encode(_ value: String) -> [UInt8] {
      value.utf8CString.flatMap { encode($0) }
    }
  }
}
