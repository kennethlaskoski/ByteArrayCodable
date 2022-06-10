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
