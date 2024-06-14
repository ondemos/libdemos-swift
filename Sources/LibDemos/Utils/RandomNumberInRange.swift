//
//  RandomNumberInRange.swift
//
//
//  Created by ondemOS on 13/6/24.
//

import Foundation

public func randomNumberInRange(min: Int, max: Int) throws -> Int {
  guard max > 0, min >= 0 else { throw UtilsError.minOrMaxIsNegative }

  guard max > min else {
    if max == min {
      return max
    }
    else {
      throw UtilsError.minBiggerThanMax(min: min, max: max)
    }
  }

  let range = max - min
  let bytesNeeded = Int(ceil(log2(Double(range)) / 8))
  let maxRange = pow(2, Double(8 * bytesNeeded))
  let extendedRange = Int(floor(maxRange / Double(range)) * Double(range))

  var randomInteger = extendedRange

  while true {
    let randomData = try randomBytes(length: bytesNeeded)
    randomInteger = randomData.reduce(0) { $0 << 8 + Int($1) }

    if randomInteger < extendedRange { return min + (randomInteger % range) }
  }

  return randomInteger
}
