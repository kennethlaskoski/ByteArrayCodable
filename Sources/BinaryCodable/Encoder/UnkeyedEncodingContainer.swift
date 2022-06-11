//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension BinaryEncoder {
  final class UnkeyedContainer: EncodingContainer, UnkeyedEncodingContainer {
    private let encoder: BinaryEncoder
    private let worker = Worker()
    private var buffer: [UInt8]

    var data: [UInt8] { buffer }

    init(encoder: BinaryEncoder) {
      self.encoder = encoder
      codingPath = encoder.codingPath
      buffer = worker.encode(0)  // the buffer's head stores `count`
    }

// MARK: - Encoding functions

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
      try value.encode(to: encoder)
      count += 1
    }

// MARK: - Protocol implementation

    var codingPath: [CodingKey]

    // The count property is mapped
    // to the buffer's head
    var count: Int {
      get {
        Int(bigEndian: buffer.withUnsafeBytes {
          $0.baseAddress!.load(as: Int.self)
        })
      }
      set {
        buffer.withUnsafeMutableBytes {
          $0.baseAddress!.assumingMemoryBound(to: Int.self).pointee = newValue.bigEndian
        }
      }
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
      fatalError("Keyed container not implemented.")
    }

    var nested: [BinaryEncoder] = []
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
      fatalError("Unkeyed container not implemented.")
//      let encoder = BinaryEncoder()
//      nested.append(encoder)
//      return encoder.unkeyedContainer()
    }

    func superEncoder() -> Encoder {
      fatalError("Super encoder not implemented.")
    }
  }
}
