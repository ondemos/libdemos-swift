  //
  //  ValidateMnemonic.swift
  //
  //
  //  Created by ondemOS on 12/6/24.
  //

import Foundation

public func mnemonicToEntropy(words: [String]) throws -> Data {
  guard words.count % 3 == 0 else {
    throw MnemonicError.numberOfWordsInMnemonicMustBeMultipleOf3
  }
  
  guard words.count >= 12 && words.count <= 48 else {
    throw MnemonicError.invalidMnemonicSize
  }
  
  let wordlist = Wordlist.data
  
  guard wordlist.count > 48 else {
    throw MnemonicError.wordlistIsEmpty
  }
  
  let bits = try words.map { word -> String in
    guard let index = wordlist.firstIndex(of: word) else {
      throw MnemonicError.couldNotFindWordInWordlist
    }
    
    return String(index, radix: 2).leftPadding(toLength: 11, withPad: "0")
  }.joined()
  
  let dividerIndex = Int(bits.count / 33) * 32
  let entropyBits = String(bits.prefix(dividerIndex))
  let checksumBits = String(bits.suffix(bits.count - dividerIndex))
  
    // Get the matching ranges for 8-bit chunks
  let regex = try NSRegularExpression(pattern: ".{1,8}", options: [])
  let matches = regex.matches(in: entropyBits, options: [], range:
                                NSRange(location: 0, length: entropyBits.count)
  )
  
    // Extract the matched substrings from the original string
  var entropyBitsMatched = [String]()
  for match in matches {
    guard let matchRange = Range(match.range, in: entropyBits) else {
      throw MnemonicError.invalidRange
    }
    
    entropyBitsMatched.append(String(entropyBits[matchRange]))
  }
  
    // Convert 8-bit chunks into UInt8 array
  let entropy = try entropyBitsMatched.map { bin -> UInt8 in
    guard let byte = UInt8(bin, radix: 2) else {
      throw MnemonicError.invalidMnemonicSize
    }
    
    return byte
  }
  
  guard entropy.count % 4 == 0 else {
    throw MnemonicError.entropyLengthNotMultipleOf4
  }
  
  guard entropy.count >= 16 && entropy.count <= 32 else {
    throw MnemonicError.strengthNotBetween128And256
  }
  
  let CS = entropy.count / 4
  let entropyHash = try SHA512(data: Data(entropy))
  
  let newChecksum = entropyHash.reduce("") { str, byte in
    str + String(byte, radix: 2).leftPadding(toLength: 8, withPad: "0")
  }.prefix(CS)
  
  if newChecksum != checksumBits {
    throw MnemonicError.invalidMnemonicChecksum(newChecksum: String(newChecksum), checksumBits: checksumBits)
  }
  
  return Data(entropy)
}

func validateMnemonic(mnemonic: [String]) -> Bool {
  do {
    let _ = try mnemonicToEntropy(words: mnemonic)
    
    return true
  } catch {
    return false
  }
}
