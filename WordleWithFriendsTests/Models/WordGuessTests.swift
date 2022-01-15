//
//  WordGuessTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 1/14/22.
//

import XCTest
@testable import WordleWithFriends

class WordGuessTests: XCTestCase {
  func testNoMatches() {
    validateGuess("BANES", against: "TRUCK", pattern: [.incorrect, .incorrect, .incorrect, .incorrect, .incorrect])
  }
  
  func testAllMisplaced() {
    validateGuess("BCDEA", against: "ABCDE", pattern: [.misplaced, .misplaced, .misplaced, .misplaced, .misplaced])
  }
  
  func testFullMatch() {
    validateGuess("PIANO", against: "PIANO", pattern: [.correct, .correct, .correct, .correct, .correct])
  }
}

extension WordGuessTests {
  func validateGuess(_ guess: String, against actualWord: String, pattern: [LetterState]) {
    assert(guess.count == actualWord.count, "Guess and actual word must be same length")
    assert(actualWord.count == pattern.count, "Expected pattern must be same length as actual word")
    
    var model = WordGuess()
    model.updateGuess(guess)
    model.checkGuess(against: actualWord)
    
    (0..<actualWord.count).forEach { index in
      let letterGuess = model.guess(at: index)!
      let expectedState = pattern[index]
      XCTAssertEqual(letterGuess.state, expectedState,
                     "Mismatch: expected letter \"\(letterGuess.letter)\" at index \(index) to be \(expectedState), was instead \(letterGuess.state)")
    }
  }
}

extension XCTestCase {
  
}
