import XCTest
@testable import LibDemos

import Foundation

final class UtilsTests: XCTestCase {
  func testRandomBytes() {
    do {
      let data1 = try randomBytes(length: 10)
      let data2 = try randomBytes(length: 10)

      XCTAssertNotEqual(data1, data2)
    } catch {
      XCTFail("ERROR: \(error)")
    }
  }

  func testSha512() {
    do {
      let data = try randomBytes(length: 100)
      let hash1 = try SHA512(data: data)
      let hash2 = try SHA512(data: data)

      XCTAssertEqual(hash1, hash2)
    } catch {
      XCTFail("ERROR: \(error)")
    }
  }

  func testMnemonic() {
    do {
      let strength = 128
      let mnemonic1 = try generateMnemonic()
      let mnemonic2 = try generateMnemonic(strength: strength)
      let mnemonic3 = try generateMnemonic(strength: strength * 2)

      XCTAssertNotEqual(mnemonic1, mnemonic2)
      XCTAssertEqual(mnemonic1.count, mnemonic2.count)
      XCTAssertEqual(mnemonic1.count, 12)
      XCTAssertEqual(mnemonic3.count, mnemonic1.count * 2)

      let validation = validateMnemonic(mnemonic: mnemonic1)
      XCTAssertTrue(validation)
    } catch {
      XCTFail("ERROR: \(error)")
    }
  }

  func testEd25519() {
    do {
      let keypair = try keyPair()
      let randomMessage = try randomBytes(length: 12)
      let signature = try sign(data: randomMessage, secretKey: keypair.secretKey)
      let verifySig = try verify(data: randomMessage, signature: signature, publicKey: keypair.publicKey)

      XCTAssertTrue(verifySig)

      let keypair1 = try keyPair()
      let verifyWrong = try verify(data: randomMessage, signature: signature, publicKey: keypair1.publicKey)

      XCTAssertFalse(verifyWrong)
    } catch {
      XCTFail("ERROR: \(error)")
    }
  }

  func testMnemonicSignVerify() {
    do {
      let mnemonic = try generateMnemonic()
      let password = "hello   libdemos"
      let keypair = try keyPairFromMnemonic(words: mnemonic, password: password)

      let randomMessage = try randomBytes(length: 12)
      let signature = try sign(data: randomMessage, secretKey: keypair.secretKey)
      let verifySig = try verify(data: randomMessage, signature: signature, publicKey: keypair.publicKey)

      XCTAssertTrue(verifySig)

      let keypair1 = try keyPairFromMnemonic(words: mnemonic, password: String(password.suffix(5)))
      let verifyWrong = try verify(data: randomMessage, signature: signature, publicKey: keypair1.publicKey)

      XCTAssertFalse(verifyWrong)

      let keypair2 = try keyPairFromMnemonic(words: mnemonic, password: password)
      let verifyRight = try verify(data: randomMessage, signature: signature, publicKey: keypair2.publicKey)

      XCTAssertTrue(verifyRight)
    } catch {
      XCTFail("ERROR: \(error)")
    }
  }

  func testRandomSelection() {
    do {
      let min = 50
      let max = 5000
      let randomNumber = try randomNumberInRange(min: min, max: max)
      let anotherRandomNumber = try randomNumberInRange(min: min, max: max)

      XCTAssertTrue(randomNumber != anotherRandomNumber)

      let randomArray = try randomBytes(length: max)
      let shuffled = try arrayRandomShuffle(array: randomArray)

      XCTAssertNotEqual(randomArray, shuffled)

      let shuffled2 = try arrayRandomShuffle(array: randomArray)

      XCTAssertNotEqual(shuffled, shuffled2)

      let subset1 = try arrayRandomSubset(array: randomArray, elements: min)
      let subset2 = try arrayRandomSubset(array: randomArray, elements: min)

      XCTAssertEqual(subset1.count, min)
      XCTAssertEqual(subset2.count, min)
      XCTAssertNotEqual(subset1, subset2)
    } catch {
      XCTFail("ERROR: \(error)")
    }
  }
}
