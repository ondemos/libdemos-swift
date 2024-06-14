  //
  //  ArrayRandomSubset.swift
  //
  //
  //  Created by ondemOS on 13/6/24.
  //

import Foundation

public func arrayRandomSubset(array: Data, elements: Int) throws -> Data {
  if array.count < elements || array.count < 2 {
    return array
  }
  
  let shuffled = try arrayRandomShuffle(array: array)
  
  return shuffled.prefix(elements)
}
