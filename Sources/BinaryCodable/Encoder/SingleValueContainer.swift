//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

extension BinaryEncoder {
  final class SingleValueContainer: SingleValueEncodingContainer {
    private var worker = Worker()
    private let encoder: BinaryEncoder

    let codingPath: [CodingKey]

    init(encoder: BinaryEncoder, codingPath: [CodingKey]) {
      self.encoder = encoder
      self.codingPath = codingPath
    }

    var data: [UInt8] { worker.data }

    public func encodeNil() throws {
      try worker.encodeNil()
    }

    public func encode(_ value: Bool) {
      worker.encode(value)
    }

    public func encode<T>(_ value: T) where T: Encodable, T: FixedWidthInteger {
      worker.encode(value)
    }

    public func encode(_ value: String) {
      worker.encode(value)
    }

    public func encode(_ value: Double) {
      worker.encode(value)
    }

    public func encode(_ value: Float) {
      worker.encode(value)
    }

    public func encode<T>(_ value: T) throws where T : Encodable {
      try value.encode(to: encoder)
    }
  }
}
