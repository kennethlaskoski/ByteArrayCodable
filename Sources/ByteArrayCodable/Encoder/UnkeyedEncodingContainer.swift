//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension ByteArrayEncoder._ByteArrayEncoder {
  final class UnkeyedContainer: EncodingContainer, UnkeyedEncodingContainer {
    var containers: [EncodingContainer] = []
    var data: [UInt8] {
      try! ByteArrayEncoder().encode(count) + containers.flatMap { $0.data }
    }

    init(codingPath: [CodingKey]) {
      self.codingPath = codingPath
    }

    // MARK: - Encoding functions

    func encodeNil() throws {
      var container = nestedSingleValueContainer()
      try container.encodeNil()
    }

    func encode<T>(_ value: T) throws
    where T: Encodable {
      var container = nestedSingleValueContainer()
      try container.encode(value)
    }

    // MARK: - Protocol implementation

    var codingPath: [CodingKey]

    var count: Int { containers.count }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<
      NestedKey
    > where NestedKey: CodingKey {
      let container = KeyedContainer<NestedKey>(codingPath: nestedCodingPath)
      containers.append(container)
      return KeyedEncodingContainer(container)
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

extension ByteArrayEncoder._ByteArrayEncoder.UnkeyedContainer {
  struct Index: CodingKey {
    var intValue: Int?
    var stringValue: String { "\(intValue!)" }

    init?(intValue: Int) { self.intValue = intValue }
    init?(stringValue: String) { nil }
  }

  private var nestedCodingPath: [CodingKey] {
    codingPath + [Index(intValue: count)!]
  }
}
