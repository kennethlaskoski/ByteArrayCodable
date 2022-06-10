//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public final class BinaryEncoder: Encoder {
  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

  private var containers: [ContainerType] = []

  public var flatData: [UInt8] {
    containers.flatMap { (container: ContainerType) -> [UInt8] in
      switch container {
      case .unkeyed(let unkeyed):
        let singleValue = SingleValueContainer(encoder: self, codingPath: [])
        singleValue.encode(unkeyed.count)

        var result = singleValue.data
        result.append(contentsOf: unkeyed.data)

        return result

      case .singleValue(let singleValue):
        return singleValue.data
      }
    }
  }

  public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() -> UnkeyedEncodingContainer {
    let newContainer = UnkeyedContainer(encoder: self, codingPath: codingPath)
    containers.append(.unkeyed(newContainer))
    return newContainer
  }

  public func singleValueContainer() -> SingleValueEncodingContainer {
    let newContainer = SingleValueContainer(encoder: self, codingPath: codingPath)
    containers.append(.singleValue(newContainer))
    return newContainer
  }
}

extension BinaryEncoder {
  private enum ContainerType {
    case unkeyed(UnkeyedContainer)
    case singleValue(SingleValueContainer)
  }
}

extension BinaryEncoder {
  struct Worker {
    private var buffer: [UInt8] = []

    var data: [UInt8] { buffer }

    mutating func encodeNil() {
      buffer.append(contentsOf: [0x3F, 0x21, 0xFF])
    }

    mutating func encode(_ value: Bool) {
      buffer.append(value ? 1 : 0)
    }

    mutating func encode<T>(_ value: T) where T: Encodable, T: FixedWidthInteger {
      withUnsafeBytes(of: value.bigEndian) {
        buffer.append(contentsOf: $0)
      }
    }

    mutating func encode(_ value: String) {
      value.utf8CString.forEach { encode($0) }
    }

    mutating func encode(_ value: Double) {
      encode(value.bitPattern)
    }

    mutating func encode(_ value: Float) {
      encode(value.bitPattern)
    }
  }
}

