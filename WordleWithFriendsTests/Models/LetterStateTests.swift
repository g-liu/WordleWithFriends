//
//  LetterStateTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/2/22.
//

import XCTest
@testable import WordleWithFriends

final class LetterStateTests: XCTestCase {
  // MARK: - priority
  func testPriority() {
    XCTAssertGreaterThan(LetterState.correct, LetterState.misplaced)
    XCTAssertGreaterThan(LetterState.misplaced, LetterState.incorrect)
    XCTAssertGreaterThan(LetterState.incorrect, LetterState.unchecked)
    XCTAssertGreaterThan(LetterState.unchecked, LetterState.invalid)
  }
}
