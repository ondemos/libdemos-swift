//
//  GetMerkleRoot.swift
//
//
//  Created by ondemOS on 13/6/24.
//

import Foundation

public func getMerkleRoot(tree: [Data]) throws -> Data {
  guard tree.count > 1 else {
    if tree.count == 0 {
      throw MerkleError.treeIsEmpty
    }
    else {
      return try SHA512(data: tree[0])
    }
  }

  var hashes = [UInt8](repeating: 0, count: tree.count * 64)
  if !tree.allSatisfy({ $0.count == 64 }) {
    for i in 0 ..< tree.count {
      let hash = try SHA512(data: tree[i])
      hashes.replaceSubrange(i * 64 ..< (i + 1) * 64, with: [UInt8](hash))
    }
  }
  else {
    hashes = [UInt8](tree.flatMap { $0 })
  }

  var concatHashes = [UInt8](repeating: 0, count: 2 * 64)

  var leaves = tree.count
  var oddLeaves = false

  while leaves > 1 {
    oddLeaves = leaves % 2 != 0

    for i in stride(from: 0, to: leaves, by: 2) {
      if oddLeaves && i + 1 == leaves {
        concatHashes.replaceSubrange(0 ..< 64, with: hashes[(i * 64) ..< ((i + 1) * 64)])
        concatHashes.replaceSubrange(64 ..< 128, with: hashes[(i * 64) ..< ((i + 1) * 64)])
      }
      else {
        concatHashes.replaceSubrange(0 ..< 64, with: hashes[(i * 64) ..< ((i + 1) * 64)])
        concatHashes.replaceSubrange(64 ..< 128, with: hashes[((i + 1) * 64) ..< ((i + 2) * 64)])
      }

      let hash = try SHA512(data: Data(concatHashes))
      hashes.replaceSubrange(i * 32 ..< i * 32 + 64, with: [UInt8](hash))
    }

    leaves = Int(ceil(Double(leaves) / 2))
  }

  return Data(hashes[0 ..< 64])
}
