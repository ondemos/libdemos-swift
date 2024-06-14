//
//  EncryptSymmetric.swift
//
//
//  Created by ondemOS on 14/6/24.
//

import Clibdemos
import Foundation

public func encryptSymmetric(message: Data, symmetricKey: Data, additionalData: Data) throws -> Data
{
  guard symmetricKey.count == 32 else { throw EncryptionError.incorrectSymmetricKeySize }

  var encrypted = [UInt8](repeating: 0, count: 12 + message.count + 16)
  let msgMemory = message.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let symMemory = symmetricKey.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let addMemory = additionalData.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }

  let res = encrypt_chachapoly_symmetric(
    UInt32(message.count),
    msgMemory,
    symMemory,
    UInt32(additionalData.count),
    addMemory,
    &encrypted
  )

  guard res == 0 else { throw EncryptionError.symmetricEncryptionError(response: Int(res)) }

  return Data(encrypted)
}
