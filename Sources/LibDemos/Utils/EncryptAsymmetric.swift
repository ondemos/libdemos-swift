//
//  EncryptAsymmetric.swift
//
//
//  Created by ondemOS on 14/6/24.
//

import Clibdemos
import Foundation

public func encryptAsymmetric(
  message: Data,
  receiverPublicKey: Data,
  senderSecretKey: Data,
  additionalData: Data
) throws -> Data {
  guard receiverPublicKey.count == 32 else { throw EncryptionError.incorrectPublicKeySize }

  guard senderSecretKey.count == 64 else { throw EncryptionError.incorrectSecretKeySize }

  var encrypted = [UInt8](repeating: 0, count: 12 + message.count + 16)
  let msgMemory = message.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let pubMemory = receiverPublicKey.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let secMemory = senderSecretKey.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let addMemory = additionalData.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }

  let res = encrypt_chachapoly_asymmetric(
    UInt32(message.count),
    msgMemory,
    pubMemory,
    secMemory,
    UInt32(additionalData.count),
    addMemory,
    &encrypted
  )

  guard res == 0 else { throw EncryptionError.encryptionError(response: Int(res)) }

  return Data(encrypted)
}
