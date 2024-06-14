//
//  ShamirError.swift
//
//
//  Created by ondemOS on 11/6/24.
//

import Foundation

enum ShamirError: Error {
  case invalidSplitResponse(response: Int32)
  case invalidRestoreResponse(response: Int32)
  case emptySharesArray
  case sharesToRestoreHaveDifferentLength
  case calculationError(reason: String)
}
