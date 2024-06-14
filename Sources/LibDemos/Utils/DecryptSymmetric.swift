//
//  DecryptSymmetric.swift
//
//
//  Created by ondemOS on 14/6/24.
//

import Clibdemos
import Foundation

public func decryptSymmetric(encrypted: Data, symmetricKey: Data, additionalData: Data) throws
  -> Data
{
  guard symmetricKey.count == 32 else { throw EncryptionError.incorrectSymmetricKeySize }

  guard encrypted.count > 12 + 16 + 1 else { throw EncryptionError.incorrectEncryptedSize }

  var decrypted = [UInt8](repeating: 0, count: encrypted.count - 12 - 16)
  let encMemory = encrypted.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let symMemory = symmetricKey.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }
  let addMemory = additionalData.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }

  let res = decrypt_chachapoly_symmetric(
    UInt32(encrypted.count),
    encMemory,
    symMemory,
    UInt32(additionalData.count),
    addMemory,
    &decrypted
  )

  guard res == 0 else { throw EncryptionError.symmetricDecryptionError(response: Int(res)) }

  return Data(decrypted)
}
