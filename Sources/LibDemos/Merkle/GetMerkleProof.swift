  //
  //  GetMerkleProof.swift
  //
  //
  //  Created by ondemOS on 13/6/24.
  //

import Foundation

public func getMerkleProof(tree: [Data], elementHash: Data) throws -> Data {
  guard tree.count > 1 else {
    if tree.count == 0 {
      throw MerkleError.treeIsEmpty
    } else {
      return try SHA512(data: tree[0])
    }
  }

  var elementOfInterest = -1
  var hashes = [UInt8](repeating: 0, count: tree.count * 64)
  if !tree.allSatisfy({ $0.count == 64 }) {
    for i in 0..<tree.count {
      let hash = try SHA512(data: tree[i])
      hashes.replaceSubrange(i * 64..<(i + 1) * 64, with: [UInt8](hash))
      if hash == elementHash {
        guard elementOfInterest == -1 else {
          throw MerkleError.elementToProveIsNotUniqueInTree
        }

        elementOfInterest = i
      }
    }
  } else {
    for i in 0..<tree.count {
      hashes.replaceSubrange(i * 64..<(i + 1) * 64, with: [UInt8](tree[i]))
      if tree[i] == elementHash {
        guard elementOfInterest == -1 else {
          throw MerkleError.elementToProveIsNotUniqueInTree
        }

        elementOfInterest = i
      }
    }
  }

  var concatHashes = [UInt8](repeating: 0, count: 2 * 64)
  var proof = [UInt8](repeating: 0, count: tree.count * 65)

  var leaves = tree.count
  var oddLeaves = false

  var k = 0 // Counts the index of proof artifacts.

  while leaves > 1 {
    oddLeaves = leaves % 2 != 0

      // For every two leaves.
    for i in stride(from: 0, to: leaves, by: 2) {
        // If we are at the last position to the right of a tree with odd number of leaves.
      if oddLeaves && i + 1 == leaves {
          // We just hash the concatenation of the last leaf's hashes
        concatHashes.replaceSubrange(0..<64, with: hashes[(i * 64)..<((i + 1) * 64)])
        concatHashes.replaceSubrange(64..<128, with: hashes[(i * 64)..<((i + 1) * 64)])

        if i == elementOfInterest {
          // We do not care if left(0) or right(1) since hash of itself
          proof.replaceSubrange(k * 65..<k * 65 + 64, with: hashes[(i * 64)..<((i + 1) * 64)])

          k += 1
          elementOfInterest = i / 2
        }
      } else {
        concatHashes.replaceSubrange(0..<64, with: hashes[(i * 64)..<((i + 1) * 64)])
        concatHashes.replaceSubrange(64..<128, with: hashes[((i + 1) * 64)..<((i + 2) * 64)])

        if i == elementOfInterest || i + 1 == elementOfInterest {
          if i == elementOfInterest {
            proof.replaceSubrange(k * 65..<k * 65 + 64, with: hashes[((i + 1) * 64)..<((i + 2) * 64)])
              // Proof artifact needs to go to the right when concatenated with
              // element.
            proof[k * 65 + 64] = 1

          } else if i + 1 == elementOfInterest {
              // Proof artifact needs to go to the left when concatenated with
              // element.
            proof.replaceSubrange(k * 65..<k * 65 + 64, with: hashes[(i * 64)..<((i + 1) * 64)])
          }

          k += 1
          elementOfInterest = i / 2
        }
      }

      let hash = try SHA512(data: Data(concatHashes))
      hashes.replaceSubrange(i * 32..<i * 32 + 64, with: [UInt8](hash))
    }

    leaves = Int(ceil(Double(leaves) / 2))
  }

  return Data(proof[0..<k * 65])
}
