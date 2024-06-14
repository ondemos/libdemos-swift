//
//  DecryptAsymmetric.swift
//
//
//  Created by ondemOS on 14/6/24.
//

import Clibdemos
import Foundation

public func decryptAsymmetric(
  encrypted: Data,
  senderPublicKey: Data,
  receiverSecretKey: Data,
  additionalData: Data
) throws -> Data {
  guard senderPublicKey.count == 32 else { throw EncryptionError.incorrectPublicKeySize }

  guard receiverSecretKey.count == 64 else { throw EncryptionError.incorrectSecretKeySize }

  guard encrypted.count > 12 + 16 + 1 else { throw EncryptionError.incorrectEncryptedSize }

  var decrypted = [UInt8](repeating: 0, count: encrypted.count - 12 - 16)
  let encMemory = encrypted.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let pubMemory = senderPublicKey.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let secMemory = receiverSecretKey.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let addMemory = additionalData.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }

  let res = decrypt_chachapoly_asymmetric(
    UInt32(encrypted.count),
    encMemory,
    pubMemory,
    secMemory,
    UInt32(additionalData.count),
    addMemory,
    &decrypted
  )

  guard res == 0 else { throw EncryptionError.decryptionError(response: Int(res)) }

  return Data(decrypted)
}
