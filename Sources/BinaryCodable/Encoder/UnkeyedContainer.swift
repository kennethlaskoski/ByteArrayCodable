//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension BinaryEncoder {
  final class UnkeyedContainer: UnkeyedEncodingContainer {
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
      fatalError("Keyed container not implemented.")
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
      fatalError("Unkeyed container not implemented.")
    }

    func superEncoder() -> Encoder {
      fatalError("Super encoder not implemented.")
    }

    private var worker = Worker()
    private let encoder: BinaryEncoder

    let codingPath: [CodingKey]
    var count: Int = 0

    init(encoder: BinaryEncoder, codingPath: [CodingKey]) {
      self.encoder = encoder
      self.codingPath = codingPath
    }

    var data: [UInt8] { worker.data }

    public func encodeNil() throws {
      try worker.encodeNil()
      count += 1
    }

    public func encode<T>(_ value: T) throws where T : Encodable {
      try value.encode(to: encoder)
      count += 1
    }
  }
}
