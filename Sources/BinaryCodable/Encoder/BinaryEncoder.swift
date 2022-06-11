//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

public final class BinaryEncoder: Encoder {
  private var containers: [ContainerType] = []

  public var data: [UInt8] {
    containers.flatMap { (container: ContainerType) -> [UInt8] in
      switch container {
      case .unkeyed(let unkeyed):
        return unkeyed.data
      case .singleValue(let singleValue):
        return singleValue.data
      }
    }
  }

  public var codingPath: [CodingKey] = []
  public var userInfo: [CodingUserInfoKey : Any] = [:]

  public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
    fatalError("Keyed container not implemented.")
  }

  public func unkeyedContainer() -> UnkeyedEncodingContainer {
    let newContainer = UnkeyedContainer(encoder: self)
    containers.append(.unkeyed(newContainer))
    return newContainer
  }

  public func singleValueContainer() -> SingleValueEncodingContainer {
    let newContainer = SingleValueContainer(encoder: self)
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
