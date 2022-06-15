//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public class ByteArrayDecoder: Decoder {
  let buffer: [UInt8]
  var offset: Int = 0

  public init(data: [UInt8]) {
    buffer = data
  }

  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

  public func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    fatalError("Unkeyed container not implemented.")
  }

  public func singleValueContainer() throws -> SingleValueDecodingContainer {
    let newContainer = SingleValueContainer(decoder: self)
    return newContainer
  }
}

extension ByteArrayDecoder {
  struct OverflowError: Error {

  }

  struct Worker {
    func decode(
      _ type: Bool.Type,
      pointer: UnsafeRawBufferPointer,
      offset: inout Int
    ) throws -> Bool {
      guard offset + 1 <= pointer.count else {
        throw OverflowError()
      }
      let value = pointer.load(fromByteOffset: offset, as: UInt8.self) == 1
      offset += 1
      return value
    }

    func decode<T>(
      _ type: T.Type,
      pointer: UnsafeRawBufferPointer,
      offset: inout Int
    ) throws -> T where T: Decodable, T: FixedWidthInteger {
      guard offset + MemoryLayout<T>.size <= pointer.count else {
        throw OverflowError()
      }
      let value = T(bigEndian: pointer.load(fromByteOffset: offset, as: T.self))
      offset += MemoryLayout<T>.size
      return value
    }

    func decode(
      _ type: String.Type,
      pointer: UnsafeRawBufferPointer,
      offset: inout Int
    ) throws -> String {
      var char: CChar
      var cString: [CChar] = []
      repeat {
        char = try decode(CChar.self, pointer: pointer, offset: &offset)
        cString.append(char)
      } while char != 0
      return String(cString: cString)
    }
  }
}
