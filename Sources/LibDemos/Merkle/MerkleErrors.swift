//
//  Merkle.swift
//
//
//  Created by ondemOS on 13/6/24.
//

import Foundation

enum MerkleError: Error {
  case treeIsEmpty
  case merkleRootCalculationError(result: Int)
  case elementToProveIsNotUniqueInTree
  case proofDoesNotHaveAccurateArtifacts
  case singleArtifactProofNotSameAsElementHash
  case artifactPositionIsNeitherLeftNorRight
  case invalidHashSize
}
