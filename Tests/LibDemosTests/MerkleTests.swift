//
//  MerkleTests.swift
//
//
//  Created by ondemOS on 13/6/24.
//

import XCTest
@testable import LibDemos

import Foundation

final class MerkleTests: XCTestCase {
  func testMerkleRootOdd() {
    do {
      let oddTree: [Data] = [
        try randomBytes(length: 29),
        try randomBytes(length: 30),
        try randomBytes(length: 100),
        try randomBytes(length: 22),
        try randomBytes(length: 56),
        try randomBytes(length: 93),
        try randomBytes(length: 10),
      ]

      let root = try getMerkleRoot(tree: oddTree)

      let element = oddTree[0]
      let elementHash = try SHA512(data: element)

      let proof = try getMerkleProof(tree: oddTree, elementHash: elementHash)
      let verified = try verifyMerkleProof(elementHash: elementHash, root: root, proof: proof)

      XCTAssertTrue(verified)

      let element1 = oddTree[4]
      let elementHash1 = try SHA512(data: element1)

      let proof1 = try getMerkleProof(tree: oddTree, elementHash: elementHash1)
      let verified1 = try verifyMerkleProof(elementHash: elementHash1, root: root, proof: proof1)

      XCTAssertTrue(verified1)

      let unverified = try verifyMerkleProof(elementHash: elementHash1, root: root, proof: proof)
      XCTAssertFalse(unverified)
    } catch {
      XCTFail("An error occured while splitting \(error)")
    }
  }

  func testMerkleRootEven() {
    do {
      let oddTree: [Data] = [
        try randomBytes(length: 29),
        try randomBytes(length: 30),
        try randomBytes(length: 100),
        try randomBytes(length: 22),
        try randomBytes(length: 93),
        try randomBytes(length: 10),
      ]

      let root = try getMerkleRoot(tree: oddTree)

      let element = oddTree[5]
      let elementHash = try SHA512(data: element)

      let proof = try getMerkleProof(tree: oddTree, elementHash: elementHash)
      let verified = try verifyMerkleProof(elementHash: elementHash, root: root, proof: proof)

      XCTAssertTrue(verified)

      let element1 = oddTree[3]
      let elementHash1 = try SHA512(data: element1)

      let proof1 = try getMerkleProof(tree: oddTree, elementHash: elementHash1)
      let verified1 = try verifyMerkleProof(elementHash: elementHash1, root: root, proof: proof1)

      XCTAssertTrue(verified1)

      let unverified = try verifyMerkleProof(elementHash: elementHash1, root: root, proof: proof)
      XCTAssertFalse(unverified)
    } catch {
      XCTFail("An error occured while splitting \(error)")
    }
  }
}

