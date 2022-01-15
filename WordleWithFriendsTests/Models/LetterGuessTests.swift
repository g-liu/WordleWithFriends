//
//  LetterGuessTests.swift
//  WordleWithFriendsTests
//
//  Created by Personal on 1/15/22.
//

import XCTest
@testable import WordleWithFriends

final class LetterGuessTests: XCTestCase {
  func testDefaultLetterGuess() {
    let def = LetterGuess.default
    XCTAssertEqual(def.letter, " ")
    XCTAssertEqual(def.state, .unchecked)
  }
  
  func testInitializationWithStateDefault() {
    let def = LetterGuess("A")
    XCTAssertEqual(def.state, .unchecked)
  }
}
