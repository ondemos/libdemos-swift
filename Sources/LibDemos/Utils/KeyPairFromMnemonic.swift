//
//  KeyPairFromMnemonic.swift
//
//
//  Created by ondemOS on 12/6/24.
//

import CryptoKit
import Foundation

public func mnemonicToSeed(words: [String], password: String?) throws -> Data {
  guard validateMnemonic(mnemonic: words) else { throw MnemonicError.invalidMnemonic }

  let mnemonic = words.joined(separator: " ").decomposedStringWithCompatibilityMapping
  guard let mnemonicBuffer = mnemonic.data(using: .utf8) else {
    throw MnemonicError.couldNotConvertMnemonicToUint8
  }

  let pwdBuffer = (password?.data(using: .utf8) ?? Data("password12345678".utf8))
  let salt = try SHA512(data: pwdBuffer).suffix(16)

  return try argon2(str: mnemonicBuffer, salt: salt)
}

public func keyPairFromMnemonic(words: [String], password: String?) throws -> SignKeyPair {
  let seed = try mnemonicToSeed(words: words, password: password)

  return try keyPairFromSeed(seed: seed)
}
