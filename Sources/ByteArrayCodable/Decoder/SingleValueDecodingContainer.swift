//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import Foundation

extension ByteArrayDecoder {
  final class SingleValueContainer: SingleValueDecodingContainer {
    private let decoder: ByteArrayDecoder
    private let worker = Worker()

    init(decoder: ByteArrayDecoder) {
      self.decoder = decoder
      codingPath = decoder.codingPath
    }

// MARK: - Decoding functions

    func decodeNil() -> Bool { false }

    func decode(_ type: Bool.Type) throws -> Bool {
      try decoder.buffer.withUnsafeBytes {
        guard let value = try? worker.decode(Bool.self, pointer: $0, offset: &decoder.offset) else {
          throw DecodingError.dataCorruptedError(in: self, debugDescription: "Buffer overflow")
        }
        return value
      }
    }

    func decode<T>(_ type: T.Type) throws -> T
    where T: Decodable, T: FixedWidthInteger {
      try decoder.buffer.withUnsafeBytes {
        guard let value = try? worker.decode(T.self, pointer: $0, offset: &decoder.offset) else {
          throw DecodingError.dataCorruptedError(in: self, debugDescription: "Buffer overflow")
        }
        return value
      }
    }

    func decode(_ type: String.Type) throws -> String {
      try decoder.buffer.withUnsafeBytes {
        guard let value = try? worker.decode(String.self, pointer: $0, offset: &decoder.offset) else {
          throw DecodingError.dataCorruptedError(in: self, debugDescription: "Buffer overflow")
        }
        return value
      }
    }

    func decode(_ type: Double.Type) throws -> Double {
      Double(bitPattern: try .init(from: decoder))
    }

    func decode(_ type: Float.Type) throws -> Float {
      Float(bitPattern: try .init(from: decoder))
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
      try T(from: decoder)
    }

// MARK: - Protocol implementation

    public var codingPath: [CodingKey]
  }
}
