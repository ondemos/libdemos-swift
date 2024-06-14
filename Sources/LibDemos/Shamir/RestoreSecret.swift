  //
  //  RestoreSecret.swift
  //
  //
  //  Created by ondemOS on 11/6/24.
  //

import Clibdemos
import Foundation

public func restoreSecret(shares: [Data]) throws -> Data {
  guard let shareLen = shares.first?.count else {
    throw ShamirError.emptySharesArray // Empty array, all elements have the same length
  }
  
  for data in shares {
    if data.count != shareLen {
      throw ShamirError.sharesToRestoreHaveDifferentLength
    }
  }
  
  let secretLen = shareLen - 1
  
  let sharesFlat = shares.reduce(into: Data()) { result, data in
    result.append(data)
  }
  
  var secretBuffer = Data(count: Int(secretLen))
  
  let result = sharesFlat.withUnsafeBytes { (sharesPtr: UnsafeRawBufferPointer) -> Int32 in
    return secretBuffer.withUnsafeMutableBytes { (secretPtr: UnsafeMutableRawBufferPointer) -> Int32 in
      guard let sharesBaseAddress = sharesPtr.baseAddress,
            let secretBaseAddress = secretPtr.baseAddress else {
        return -1
      }
      
      return restore_secret(UInt32(shares.count), UInt32(secretLen), OpaquePointer(sharesBaseAddress), secretBaseAddress)
    }
  }
  
  guard result == 0 else {
    throw ShamirError.invalidSplitResponse(response: result)
  }
  
  return secretBuffer
}
