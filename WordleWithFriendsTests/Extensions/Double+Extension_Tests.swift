//
//  Double+Extension_Tests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/15/22.
//

import XCTest
@testable import WordleWithFriends

final class DoubleExtensionTests: XCTestCase {
  func testConvertZeroSecondsToMinutesSeconds() {
    let timeRemaining: TimeInterval = 0
    let result = timeRemaining.asMinutesSeconds
    XCTAssertEqual(result, "00:00")
  }
  
  func testConvertLessThan60SecondsToMinutesSeconds() {
    let timeRemaining: TimeInterval = 48
    let result = timeRemaining.asMinutesSeconds
    XCTAssertEqual(result, "00:48")
  }
  
  func testConvertMultipleOf60SecondsToMinutesSeconds() {
    let timeRemaining: TimeInterval = 1440
    let result = timeRemaining.asMinutesSeconds
    XCTAssertEqual(result, "24:00")
  }
  
  func testConvertArbitrarySecondsToMinutesSeconds() {
    let timeRemaining: TimeInterval = 1234
    let result = timeRemaining.asMinutesSeconds
    XCTAssertEqual(result, "20:34")
  }
}
