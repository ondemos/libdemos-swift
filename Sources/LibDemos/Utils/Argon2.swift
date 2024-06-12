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
  
  var sal = [UInt8](s)
  var mnemonicInt8Array = str.map { Int8(bitPattern: $0) }
  var hash = [UInt8](repeating: 0, count: 32)
  let result = argon2(UInt32(str.count), &hash, &mnemonicInt8Array, &sal)
  guard result == 0 else {
    throw UtilsError.couldNotCalculateArgon2
  }
  
  return Data(hash)
}
