//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension BinaryEncoder {
  final class SingleValueContainer: SingleValueEncodingContainer {
    private let encoder: BinaryEncoder
    private let worker = EncodingWorker()
    private var buffer: [UInt8] = []

    var data: [UInt8] { buffer }

    init(encoder: BinaryEncoder) {
      self.encoder = encoder
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

    func encode(_ value: Bool) {
      let bytes = worker.encode(value)
      buffer.append(contentsOf: bytes)
    }

    func encode<T>(_ value: T)
    where T: Encodable, T: FixedWidthInteger
    {
      let bytes = worker.encode(value)
      buffer.append(contentsOf: bytes)
    }

    func encode(_ value: String) {
      let bytes = worker.encode(value)
      buffer.append(contentsOf: bytes)
    }

    func encode(_ value: Double) {
      encode(value.bitPattern)
    }

    func encode(_ value: Float) {
      encode(value.bitPattern)
    }

    func encode<T>(_ value: T) throws
    where T : Encodable
    {
      try value.encode(to: encoder)
    }

// MARK: - Protocol implementation

    var codingPath: [CodingKey] { [] }
  }
}
