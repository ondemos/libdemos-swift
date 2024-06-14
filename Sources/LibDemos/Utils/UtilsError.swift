//
//  File.swift
//
//
//  Created by ondemOS on 11/6/24.
//

import Foundation

enum UtilsError: Error {
  case couldNotGenerateSecureRandomBytes
  case couldNotCalculateSha512
  case sha512CalculationError(result: Int32)
  case couldNotCalculateArgon2
  case couldNotGenerateEd25519KeyPair(error: Int)
  case couldNotGenerateSignature(error: Int)
  case couldNotVerifySignature(error: Int)
  case minBiggerThanMax(min: Int, max: Int)
  case minOrMaxIsNegative
}

enum EncryptionError: Error {
  case encryptionError(response: Int)
  case symmetricEncryptionError(response: Int)
  case decryptionError(response: Int)
  case symmetricDecryptionError(response: Int)
  case secretKeyIsInLibsodiumFormat
  case incorrectPublicKeySize
  case incorrectSecretKeySize
  case incorrectEncryptedSize
  case incorrectSymmetricKeySize
  case incorrectSignatureSize
}

enum MnemonicError: Error {
  case strengthIsNotDivisibleBy32(strength: Int)
  case wordlistNotLoaded
  case wordlistIsEmpty
  case invalidMnemonicSize
  case strengthNotBetween128And256
  case numberOfWordsInMnemonicMustBeMultipleOf3
  case couldNotFindWordInWordlist
  case couldNotConvertMnemonicToUint8
  case invalidMnemonicChecksum(newChecksum: String, checksumBits: String)
  case invalidWordIndex
  case invalidRange
  case invalidMnemonic
  case entropyLengthNotMultipleOf4
  case conversionToRangeFailed
}
