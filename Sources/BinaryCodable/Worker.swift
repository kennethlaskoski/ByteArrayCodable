//  Copyright Kenneth Laskoski. All Rights Reserved.
//  SPDX-License-Identifier: MIT

struct EncodingWorker {
  func encode(_ value: Bool) -> [UInt8] {
    [value ? 1 : 0]
  }

  func encode<T>(_ value: T) -> [UInt8]
  where T: Encodable, T: FixedWidthInteger
  {
    withUnsafeBytes(of: value.bigEndian) { $0.map { $0 } }
  }

  func encode(_ value: String) -> [UInt8] {
    value.utf8CString.flatMap { encode($0) }
  }
}

struct DecodingWorker {
  func decode(_ type: Bool.Type, cursor: UnsafeRawPointer)
  throws -> Bool
  {
    cursor.load(as: UInt8.self) == 1
  }

  func decode<T>(_ type: T.Type, cursor: UnsafeRawPointer)
  throws -> T
  where T: Decodable, T: FixedWidthInteger
  {
    T(bigEndian: cursor.load(as: T.self))
  }

//  func encode(_ value: String) -> [UInt8] {
//    value.utf8CString.flatMap { encode($0) }
//  }
}
