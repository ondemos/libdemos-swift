//
//  KeyPair.swift
//
//
//  Created by ondemOS on 12/6/24.
//

import Clibdemos
import Foundation

#if canImport(CryptoKit)
  import CryptoKit
#endif

public struct SignKeyPair {
  let secretKey: Data
  let publicKey: Data
}

public func keyPair() throws -> SignKeyPair {
  #if canImport(CryptoKit)
    if #available(iOS 13.0, macOS 10.15, *) {
      let privateKey = Curve25519.Signing.PrivateKey()

      return SignKeyPair(
        secretKey: privateKey.rawRepresentation + privateKey.publicKey.rawRepresentation,
        publicKey: privateKey.publicKey.rawRepresentation
      )
    }
    else {
      var publicKey = [UInt8](repeating: 0, count: 32)
      var secretKey = [UInt8](repeating: 0, count: 64)

      let result = keypair(&publicKey, &secretKey)
      guard result == 0 else { throw UtilsError.couldNotGenerateEd25519KeyPair(error: Int(result)) }

      return SignKeyPair(secretKey: Data(secretKey), publicKey: Data(publicKey))
    }
  #else
    var publicKey = [UInt8](repeating: 0, count: 32)
    var secretKey = [UInt8](repeating: 0, count: 64)

    let result = keypair(&publicKey, &secretKey)
    guard result == 0 else { throw UtilsError.couldNotGenerateEd25519KeyPair(error: Int(result)) }

    return SignKeyPair(secretKey: Data(secretKey), publicKey: Data(publicKey))
  #endif
}

public func keyPairFromSeed(seed: Data) throws -> SignKeyPair {
  var publicKey = [UInt8](repeating: 0, count: 32)
  var secretKey = [UInt8](repeating: 0, count: 64)
  let seedMemory = seed.withUnsafeBytes { (unsafeBytes) in
    return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
  }

  let result = keypair_from_seed(&publicKey, &secretKey, seedMemory)
  guard result == 0 else { throw UtilsError.couldNotGenerateEd25519KeyPair(error: Int(result)) }

  return SignKeyPair(secretKey: Data(secretKey), publicKey: Data(publicKey))
}

public func sign(data: Data, secretKey: Data) throws -> Data {
  guard secretKey.count == 64 else { throw EncryptionError.incorrectSecretKeySize }

  #if canImport(CryptoKit)
    if #available(iOS 13.0, macOS 10.15, *) {
      let privateKey = try Curve25519.Signing.PrivateKey.init(
        rawRepresentation: secretKey.prefix(32)
      )

      let signature = try privateKey.signature(for: data)

      return signature
    }
    else {
      var signature = [UInt8](repeating: 0, count: 64)
      let dataMemory = data.withUnsafeBytes { (unsafeBytes) in
        return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
      }
      let secMemory = secretKey.withUnsafeBytes { (unsafeBytes) in
        return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
      }

      let result = sign(Int32(data.count), dataMemory, secMemory, &signature)
      guard result == 0 else { throw UtilsError.couldNotGenerateSignature(error: Int(result)) }

      return Data(signature)
    }
  #else
    var signature = [UInt8](repeating: 0, count: 64)
    let dataMemory = data.withUnsafeBytes { (unsafeBytes) in
      return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
    }
    let secMemory = secretKey.withUnsafeBytes { (unsafeBytes) in
      return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
    }

    let result = sign(Int32(data.count), dataMemory, secMemory, &signature)
    guard result == 0 else { throw UtilsError.couldNotGenerateSignature(error: Int(result)) }

    return Data(signature)
  #endif
}

public func verify(data: Data, signature: Data, publicKey: Data) throws -> Bool {
  guard publicKey.count == 32 else { throw EncryptionError.incorrectPublicKeySize }

  guard signature.count == 64 else { throw EncryptionError.incorrectSignatureSize }

  #if canImport(CryptoKit)
    if #available(iOS 13.0, macOS 10.15, *) {
      let publicKey = try Curve25519.Signing.PublicKey.init(rawRepresentation: publicKey)

      return publicKey.isValidSignature(signature, for: data)
    }
    else {
      let dataMemory = data.withUnsafeBytes { (unsafeBytes) in
        return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
      }
      let sigMemory = signature.withUnsafeBytes { (unsafeBytes) in
        return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
      }
      let pubMemory = publicKey.withUnsafeBytes { (unsafeBytes) in
        return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
      }
      let result = verify(Int32(data.count), dataMemory, pubMemory, sigMemory)
      guard result == 0 else { return false }

      return true
    }
  #else
    let dataMemory = data.withUnsafeBytes { (unsafeBytes) in
      return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
    }
    let sigMemory = signature.withUnsafeBytes { (unsafeBytes) in
      return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
    }
    let pubMemory = publicKey.withUnsafeBytes { (unsafeBytes) in
      return unsafeBytes.bindMemory(to: UInt8.self).baseAddress!
    }
    let result = verify(Int32(data.count), dataMemory, pubMemory, sigMemory)
    guard result == 0 else { return false }

    return true
  #endif
}
