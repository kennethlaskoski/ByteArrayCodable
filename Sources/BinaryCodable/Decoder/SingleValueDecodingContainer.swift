//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

import Foundation

extension BinaryDecoder {
  final class SingleValueContainer: SingleValueDecodingContainer {
    private let decoder: BinaryDecoder
    private let worker = DecodingWorker()

    init(decoder: BinaryDecoder) {
      self.decoder = decoder
    }

// MARK: - Decoding functions

    func decodeNil() -> Bool {
      false
    }

    func decode(_ type: Bool.Type) throws -> Bool {
      try decoder.buffer.withUnsafeBytes {
        let cursor = $0.baseAddress!.advanced(by: decoder.offset)
        let result = try worker.decode(Bool.self, cursor: cursor)
        decoder.offset += 1
        return result
      }
    }

    func decode<T>(_ type: T.Type) throws -> T
    where T: Decodable, T: FixedWidthInteger
    {
      try decoder.buffer.withUnsafeBytes {
        let cursor = $0.baseAddress!.advanced(by: decoder.offset)
        let result = try worker.decode(T.self, cursor: cursor)
        decoder.offset += MemoryLayout<T>.size
        return result
      }
    }

    func decode(_ type: String.Type) throws -> String {
      fatalError("Not implemented.")
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

    public var codingPath: [CodingKey] { [] }
  }
}
