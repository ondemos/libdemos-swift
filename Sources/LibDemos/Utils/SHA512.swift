  //
  //  SHA512.swift
  //
  //
  //  Created by ondemOS on 11/6/24.
  //

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#else
import Clibdemos
#endif

public func SHA512(data: Data) throws -> Data {
#if canImport(CryptoKit)
  if #available(iOS 13.0, macOS 10.15, *) {
    let hash = SHA512.hash(data: data)
    
    return Data(hash)
  } else {
    throw UtilsError.couldNotCalculateSha512
  }
#else
  var hash = [UInt8](repeating: 0, count: 64)
  let dataLength = UInt32(data.count)
  
  let result = data.withUnsafeBytes { (dataPtr: UnsafeRawBufferPointer) -> Int32 in
    return sha512(dataLength, dataPtr.baseAddress!.assumingMemoryBound(to: UInt8.self), &hash)
  }
  
  guard result == 0 else {
    throw UtilsError.couldNotCalculateSha512
  }
  
  return Data(hash)
#endif
}
