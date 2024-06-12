  //
  //  GenerateMnemonic.swift
  //
  //
  //  Created by ondemOS on 11/6/24.
  //

import Foundation
import Security

public struct Wordlist {
  static let data: [String] = {
    guard let url = Bundle.module.url(forResource: "wordlist", withExtension: "json") else {
      return []
    }
    
    do {
      let data = try Data(contentsOf: url)
      let stringArray = try JSONDecoder().decode([String].self, from: data).sorted()
      
      return stringArray
    } catch {
      print("Error loading JSON file:", error)
      return []
    }
  }()
}

public extension String {
  func leftPadding(toLength: Int, withPad character: Character) -> String {
    let stringLength = self.count
    if stringLength < toLength {
      return String(repeatElement(character, count: toLength - stringLength)) + self
    } else {
      return String(self.suffix(toLength))
    }
  }
}

public func generateMnemonic(strength: Int = 128) throws -> [String] {
  guard strength % 32 == 0 else {
    throw MnemonicError.strengthIsNotDivisibleBy32(strength: strength)
  }
  
  let wordlist = Wordlist.data
  
  guard wordlist.count > 0 else {
    throw MnemonicError.wordlistIsEmpty
  }
  
  let entropyBytesLen = strength / 8
  guard entropyBytesLen >= 16 && entropyBytesLen <= 32 else {
    throw MnemonicError.strengthNotBetween128And256
  }
  
  let entropy = try randomBytes(length: entropyBytesLen)
  let entropyBits = entropy.map {
    String($0, radix: 2).leftPadding(toLength: 8, withPad: "0")
  }.joined()
  
  let CS = strength / 32
  let entropyHash = try SHA512(data: Data(entropy))
  let checksumBits = entropyHash.map {
    String($0, radix: 2).leftPadding(toLength: 8, withPad: "0")
  }.joined().prefix(CS)
  
  let bits = entropyBits + String(checksumBits)
  
  let regex = try NSRegularExpression(pattern: ".{1,11}")
  let chunks = regex.matches(in: bits, range: NSRange(bits.startIndex..., in: bits))
  
  let words = try chunks.map {
    let bit = String(bits[Range($0.range(at: 0), in: bits)!])
    guard let index = Int(bit, radix: 2), index < wordlist.count else {
      throw MnemonicError.invalidWordIndex
    }
    
    return wordlist[index]
  }
  
  return words
}
