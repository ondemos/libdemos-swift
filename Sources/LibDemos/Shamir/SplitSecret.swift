  //
  //  SplitSecret.swift
  //
  //
  //  Created by ondemOS on 11/6/24.
  //

import Clibdemos
import Foundation

public func splitSecret(secret: Data, sharesLen: UInt, theshold: UInt) throws -> [Data] {
  let totalSharesLen = Int(sharesLen) * (secret.count + 1)
  var data = ContiguousArray<UInt8>(repeating: 0, count: totalSharesLen)
  
  let result = data.withUnsafeMutableBufferPointer { (ptr: inout UnsafeMutableBufferPointer<UInt8>) -> Int32 in
    return split_secret(UInt32(sharesLen), UInt32(theshold), UInt32(secret.count), [UInt8](secret), OpaquePointer(ptr.baseAddress))
  }
  
  guard result == 0 else {
    throw ShamirSharingError.invalidSplitResponse(response: result)
  }
  
  var shares: [Data] = []
  for i in 0..<Int(sharesLen) {
    let share = Data(data).subdata(in: (i * (secret.count + 1))..<((i + 1) * (secret.count + 1)))
    shares.append(share)
  }
  
  return shares
}
