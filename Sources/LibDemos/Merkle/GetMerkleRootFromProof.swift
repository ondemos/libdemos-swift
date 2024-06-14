  //
  //  GetMerkleRootFromProof.swift
  //
  //
  //  Created by ondemOS on 13/6/24.
  //

import Foundation

public func getMerkleRootFromProof(elementHash: Data, proof: Data) throws -> Data {
  guard proof.count % 65 == 0, proof.count > 0 else {
    throw MerkleError.proofDoesNotHaveAccurateArtifacts
  }

  let proofArtifactsLen = proof.count / 65

  var root = [UInt8](elementHash)

  if proofArtifactsLen == 1 {
    if elementHash == proof.prefix(64) {
      return elementHash
    } else {
      throw MerkleError.singleArtifactProofNotSameAsElementHash
    }
  }

  var concatHashes = [UInt8](repeating: 0, count: 2 * 64)

  for i in 0..<proofArtifactsLen {
    let position = proof[i * 65 + 64]

      // Proof artifact goes to the left
    if position == 0 {
      concatHashes.replaceSubrange(0..<64, with: proof[i * 65..<i * 65 + 64])
      concatHashes.replaceSubrange(64..<128, with: root)
    } else if position == 1 {
        // Proof artifact goes to the right
      concatHashes.replaceSubrange(0..<64, with: root)
      concatHashes.replaceSubrange(64..<128, with: proof[i * 65..<i * 65 + 64])
    } else {
      throw MerkleError.artifactPositionIsNeitherLeftNorRight
    }

    let hash = try SHA512(data: Data(concatHashes))
    root.replaceSubrange(0..<64, with: [UInt8](hash))
  }

  return Data(root)
}
