//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension ByteArrayEncoder._ByteArrayEncoder {
  final class KeyedContainer<Key: CodingKey>: EncodingContainer, KeyedEncodingContainerProtocol {
    var containers: [EncodingContainer] = []
    var data: [UInt8] { containers.flatMap { $0.data } }

    init(codingPath: [CodingKey]) {
      self.codingPath = codingPath
    }

// MARK: - Encoding functions

    func encodeNil(forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Bool, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: String, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Double, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Float, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Int, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Int8, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Int16, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Int32, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: Int64, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: UInt, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: UInt8, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: UInt16, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: UInt32, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode(_ value: UInt64, forKey key: Key) throws {
      fatalError("Keyed container not implemented.")
    }

    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
      fatalError("Keyed container not implemented.")
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
      fatalError("Keyed container not implemented.")
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
      fatalError("Keyed container not implemented.")
    }

    func superEncoder(forKey key: Key) -> Encoder {
      fatalError("Keyed container not implemented.")
    }

    func encodeNil() throws {
      throw EncodingError.invalidValue(
        UInt8?.none as Any,
        .init(
          codingPath: codingPath,
          debugDescription: "Encoding nil is not supported."
        )
      )
    }

    func encode<T>(_ value: T) throws
    where T : Encodable
    {
      var container = nestedSingleValueContainer()
      try container.encode(value)
    }

// MARK: - Protocol implementation

    var codingPath: [CodingKey]

    var count: Int { containers.count }

    func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
      fatalError("Keyed container not implemented.")
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
      let container = UnkeyedContainer(codingPath: nestedCodingPath)
      containers.append(container)
      return container
    }

    func nestedSingleValueContainer() -> SingleValueEncodingContainer {
      let container = SingleValueContainer(codingPath: nestedCodingPath)
      containers.append(container)
      return container
    }

    func superEncoder() -> Encoder {
      fatalError("Super encoder not implemented.")
    }
  }
}

extension ByteArrayEncoder._ByteArrayEncoder.KeyedContainer {
  struct Index: CodingKey {
    var intValue: Int?
    var stringValue: String {
      return "\(self.intValue!)"
    }
    init?(intValue: Int) {
      self.intValue = intValue
    }
    init?(stringValue: String) {
      return nil
    }
  }

  private var nestedCodingPath: [CodingKey] {
    codingPath + [Index(intValue: self.count)!]
  }
}
