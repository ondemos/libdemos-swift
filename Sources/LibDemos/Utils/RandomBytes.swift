//
//  File.swift
//
//
//  Created by ondemOS on 11/6/24.
//

import Foundation
import Security

public func randomBytes(length: Int) throws -> Data {
  var data = Data(count: length)
  let result = data.withUnsafeMutableBytes { mutableBytes in
    SecRandomCopyBytes(kSecRandomDefault, length, mutableBytes.baseAddress!)
  }

  guard result == errSecSuccess else { throw UtilsError.couldNotGenerateSecureRandomBytes }

  return data
}
