import Foundation
import XCTest

@testable import LibDemos

final class ShamirTests: XCTestCase {
  func testSplitRestoreSecret() {
    let sharesLen: UInt = 4
    let threshold: UInt = 3
    let secret = Data([0, 1, 2, 3, 4, 5, 7, 30])

    var shares: [Data] = []

    do {
      shares = try splitSecret(secret: secret, sharesLen: sharesLen, theshold: threshold)

      XCTAssertEqual(shares.count, Int(sharesLen), "Unexpected number of shares")
    }
    catch { XCTFail("An error occured while splitting \(error)") }

    do {
      let restoredSecret = try restoreSecret(shares: Array(shares.prefix(Int(threshold))))

      XCTAssertEqual(restoredSecret, secret, "Restored secret does not match expected secret")
    }
    catch { XCTFail("An error occured while restoring \(error)") }
  }
}
