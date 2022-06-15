//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension ByteArrayEncoder._ByteArrayEncoder {
  final class KeyedContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {
    var containers: [String: EncodingContainer] = [:]

    init(codingPath: [CodingKey]) {
      self.codingPath = codingPath
    }

    // MARK: - Protocol functions
    // MARK: Encoding

    func encodeNil(forKey key: Key) throws {
      var container = nestedSingleValueContainer(forKey: key)
      try container.encodeNil()
    }

    func encode<T>(_ value: T, forKey key: Key) throws
    where T: Encodable {
      var container = nestedSingleValueContainer(forKey: key)
      try container.encode(value)
    }

    // MARK: Nested containers

    func nestedContainer<NestedKey>(
      keyedBy keyType: NestedKey.Type,
      forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
      let container = KeyedContainer<NestedKey>(codingPath: nestedCodingPath(forKey: key))
      containers[key.stringValue] = container
      return KeyedEncodingContainer(container)
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
      let container = UnkeyedContainer(codingPath: nestedCodingPath(forKey: key))
      containers[key.stringValue] = container
      return container
    }

    func nestedSingleValueContainer(forKey key: Key) -> SingleValueEncodingContainer {
      let container = SingleValueContainer(codingPath: nestedCodingPath(forKey: key))
      containers[key.stringValue] = container
      return container
    }

    func superEncoder(forKey key: Key) -> Encoder {
      fatalError("Super wncoder not implemented.")
    }

    func superEncoder() -> Encoder {
      fatalError("Super encoder not implemented.")
    }

    // MARK: - Protocol properties

    var codingPath: [CodingKey]
  }
}

// MARK: - EncodingContainer implementation
extension ByteArrayEncoder._ByteArrayEncoder.KeyedContainer: EncodingContainer {
  var data: [UInt8] {
    var buffer: [UInt8] = []
    buffer.append(contentsOf: try! ByteArrayEncoder().encode(containers.count))
    for (key, container) in containers {
      buffer.append(contentsOf: try! ByteArrayEncoder().encode(key))
      buffer.append(contentsOf: container.data)
    }
    return buffer
  }
}

// MARK: - Nesting utility
extension ByteArrayEncoder._ByteArrayEncoder.KeyedContainer {
  private func nestedCodingPath(forKey key: CodingKey) -> [CodingKey] {
    codingPath + [key]
  }
}
