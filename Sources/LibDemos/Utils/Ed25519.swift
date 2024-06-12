  //
  //  KeyPair.swift
  //
  //
  //  Created by ondemOS on 12/6/24.
  //

import Foundation
import Clibdemos
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
    
    return SignKeyPair(secretKey: privateKey.rawRepresentation, publicKey: privateKey.publicKey.rawRepresentation)
  } else {
    var secretKey = [UInt8](repeating: 0, count: 64)
    var publicKey = [UInt8](repeating: 0, count: 32)
    
    let result = keypair(&publicKey, &secretKey)
    guard result == 0 else {
      throw UtilsError.couldNotGenerateEd25519KeyPair(error: Int(result))
    }
    
    return SignKeyPair(secretKey: Data(secretKey).prefix(32), publicKey: Data(publicKey))
  }
#else
  var secretKey = [UInt8](repeating: 0, count: 64)
  var publicKey = [UInt8](repeating: 0, count: 32)
  
  let result = keypair(&publicKey, &secretKey)
  guard result == 0 else {
    throw UtilsError.couldNotGenerateEd25519KeyPair(error: Int(result))
  }
  
  return SignKeyPair(secretKey: Data(secretKey).prefix(32), publicKey: Data(publicKey))
#endif
}

public func keyPairFromSeed(seed: Data) throws -> SignKeyPair {
  var secretKey = [UInt8](repeating: 0, count: 64)
  var publicKey = [UInt8](repeating: 0, count: 32)
  var s = [UInt8](seed)
  
  let result = keypair_from_seed(&publicKey, &secretKey, &s)
  guard result == 0 else {
    throw UtilsError.couldNotGenerateEd25519KeyPair(error: Int(result))
  }
  
  return SignKeyPair(secretKey: Data(secretKey).prefix(32), publicKey: Data(publicKey))
}

public func sign(data: Data, secretKey: Data) throws -> Data {
#if canImport(CryptoKit)
  if #available(iOS 13.0, macOS 10.15, *) {
    let privateKey = try Curve25519.Signing.PrivateKey.init(rawRepresentation: secretKey)
    
    let signature = try privateKey.signature(for: data)
    
    return signature
  } else {
    var signature = [UInt8](repeating: 0, count: 64)
    var dataArray = [UInt8](data)
    var sec = [UInt8](secretKey)
    let result = sign(Int32(data.count), &dataArray, &sec, &signature)
    guard result == 0 else {
      throw UtilsError.couldNotGenerateSignature(error: Int(result))
    }
    
    return Data(signature)
  }
#else
  var signature = [UInt8](repeating: 0, count: 64)
  var dataArray = [UInt8](data)
  var sec = [UInt8](secretKey)
  let result = sign(Int32(data.count), &dataArray, &sec, &signature)
  guard result == 0 else {
    throw UtilsError.couldNotGenerateSignature(error: Int(result))
  }
  
  return Data(signature)
#endif
}

public func verify(data: Data, signature: Data, publicKey: Data) throws -> Bool {
#if canImport(CryptoKit)
  if #available(iOS 13.0, macOS 10.15, *) {
    let publicKey = try Curve25519.Signing.PublicKey.init(rawRepresentation: publicKey)
    
    return publicKey.isValidSignature(signature, for: data)
  } else {
    var sig = [UInt8](signature)
    var dataArray = [UInt8](data)
    var pub = [UInt8](publicKey)
    let result = verify(Int32(data.count), &dataArray, &pub, &sig)
    guard result == 0 else {
      return false
    }
    
    return true
  }
#else
  var sig = [UInt8](signature)
  var dataArray = [UInt8](data)
  var pub = [UInt8](publicKey)
  let result = verify(Int32(data.count), &dataArray, &pub, &sig)
  guard result == 0 else {
    return false
  }
  
  return true
#endif
}

