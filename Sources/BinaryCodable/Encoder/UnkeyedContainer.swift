//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension BinaryEncoder {
  final class UnkeyedContainer: UnkeyedEncodingContainer {
    private let encoder: BinaryEncoder
    private let worker = EncodingWorker()
    private var buffer: [UInt8]

    var data: [UInt8] { buffer }

    init(encoder: BinaryEncoder) {
      self.encoder = encoder
      self.buffer = worker.encode(0)
    }

// MARK: - Encoding functions

    func encodeNil() throws {
      throw EncodingError.invalidValue(
        Any.self,
        .init(
          codingPath: codingPath,
          debugDescription: "Sorry, this encoder does not encode nil"
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

    var codingPath: [CodingKey] { [] }

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

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
      fatalError("Unkeyed container not implemented.")
    }

    func superEncoder() -> Encoder {
      fatalError("Super encoder not implemented.")
    }
  }
}
