//
//  ArrayRandomShuffle.swift
//
//
//  Created by ondemOS on 13/6/24.
//

import Foundation

public func arrayRandomShuffle(array: Data) throws -> Data {
  if array.count < 2 { return array }

  var newArray = Data(array)

  for i in stride(from: array.count - 1, to: 0, by: -1) {
    let j = try randomNumberInRange(min: 0, max: i + 1)
    let tmp = newArray[i]
    newArray[i] = newArray[j]
    newArray[j] = tmp
  }

  return newArray
}
