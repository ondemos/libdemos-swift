  //
  //  Argon2.swift
  //
  //
  //  Created by ondemOS on 11/6/24.
  //

import Clibdemos
import Foundation

public func argon2(str: Data, salt: Data?) throws -> Data {
  var s = salt ?? Data(repeating: 0, count: 16)
  if salt == nil || salt?.count != 16 {
    s = try randomBytes(length: 16)
  }

  var hash = [UInt8](repeating: 0, count: 32)
  let salMemory = s.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let mnemonicInt8Array = str.map { Int8(bitPattern: $0) }
  let result = argon2(UInt32(str.count), &hash, mnemonicInt8Array, salMemory)
  guard result == 0 else {
    throw UtilsError.couldNotCalculateArgon2
  }
  
  return Data(hash)
}
