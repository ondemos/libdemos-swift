//
//  VerifyMerkleProof.swift
//
//
//  Created by ondemOS on 13/6/24.
//

import Foundation

public func verifyMerkleProof(elementHash: Data, root: Data, proof: Data) throws -> Bool {
  let calculatedRoot = try getMerkleRootFromProof(elementHash: elementHash, proof: proof)

  return calculatedRoot == root
}
