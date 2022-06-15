//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension ByteArrayEncoder._ByteArrayEncoder {
  final class SingleValueContainer: EncodingContainer, SingleValueEncodingContainer {
    private let worker = Worker()
    private var buffer: [UInt8] = []

    var data: [UInt8] { buffer }

    init(codingPath: [CodingKey]) {
      self.codingPath = codingPath
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
      let encoder = ByteArrayEncoder()
      buffer.append(contentsOf: try encoder.encode(value))
    }

// MARK: - Protocol implementation

    var codingPath: [CodingKey]
  }
}
