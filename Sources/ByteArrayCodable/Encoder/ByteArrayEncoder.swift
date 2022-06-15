//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public final class ByteArrayEncoder {
  // TODO: Swift 5.7
  // public func encode(_ value: some Encodable) throws -> [UInt8] {
  public func encode<T: Encodable>(_ value: T) throws -> [UInt8] {
    let encoder = _ByteArrayEncoder()
    try value.encode(to: encoder)
    return encoder.data
  }
}

#if canImport(Combine)
import Combine
extension ByteArrayEncoder: TopLevelEncoder {}
#endif

protocol EncodingContainer {
  var data: [UInt8] { get }
}

extension ByteArrayEncoder {
  final class _ByteArrayEncoder: Encoder {
    private var containers: [EncodingContainer] = []

    public var data: [UInt8] {
      containers.flatMap { $0.data }
    }

    public var codingPath: [CodingKey] = []
    public var userInfo: [CodingUserInfoKey : Any] = [:]

    public func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
      let container = KeyedContainer<Key>(codingPath: codingPath)
      containers.append(container)
      return KeyedEncodingContainer(container)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
      let container = UnkeyedContainer(codingPath: codingPath)
      containers.append(container)
      return container
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
      let container = SingleValueContainer(codingPath: codingPath)
      containers.append(container)
      return container
    }
  }
}

extension ByteArrayEncoder._ByteArrayEncoder {
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
