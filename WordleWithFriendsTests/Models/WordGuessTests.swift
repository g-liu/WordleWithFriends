//
//  WordGuessTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 1/14/22.
//

import XCTest
@testable import WordleWithFriends

class WordGuessTests: XCTestCase {
  func testSmokeTests() {
    validateGuess("CATER", against: "RATED", pattern: [.incorrect, .correct, .correct, .correct, .misplaced])
    validateGuess("SMOKE", against: "WATER", pattern: [.incorrect, .incorrect, .incorrect, .incorrect, .misplaced])
    validateGuess("FRIED", against: "OKRAS", pattern: [.incorrect, .misplaced, .incorrect, .incorrect, .incorrect])
    validateGuess("STARS", against: "TARTS", pattern: [.incorrect, .misplaced, .misplaced, .misplaced, .correct])
    validateGuess("STEMS", against: "MASTS", pattern: [.misplaced, .misplaced, .incorrect, .misplaced, .correct])
  }
  
  func testNoMatches() {
    validateGuess("BANES", against: "TRUCK", pattern: [.incorrect, .incorrect, .incorrect, .incorrect, .incorrect])
  }
  
  func testAllMisplaced() {
    validateGuess("BCDEA", against: "ABCDE", pattern: [.misplaced, .misplaced, .misplaced, .misplaced, .misplaced])
  }
  
  func testMoreMisplacedLettersThanPresentInActualWord() {
    validateGuess("TATER", against: "TANGY", pattern: [.correct, .correct, .incorrect, .incorrect, .incorrect])
  }
  
  func testAllMisplacedExceptOne() {
    validateGuess("BBCAA", against: "AACBB", pattern: [.misplaced, .misplaced, .correct, .misplaced, .misplaced])
  }
  
  func testMixedNumbersOfTwoLetters() {
    validateGuess("BBBBC", against: "CCCCB", pattern: [.misplaced, .incorrect, .incorrect, .incorrect, .misplaced])
    validateGuess("BCBBB", against: "CBCCC", pattern: [.misplaced, .misplaced, .incorrect, .incorrect, .incorrect])
  }
  
  func testFullMatch() {
    validateGuess("PIANO", against: "PIANO", pattern: [.correct, .correct, .correct, .correct, .correct])
  }
  
  func testForceStateMisplaced() {
    let guess = "CRACK"
    var model = WordGuess()
    model.updateGuess(guess)
    model.forceState(.misplaced)
    (0..<guess.count).forEach { index in
      XCTAssertEqual(model.guess(at: index)?.state, .misplaced)
    }
  }
  
  func testUpdateGuessToDifferentLength() {
    let firstGuess = "DOPES"
    let secondGuess = "MAGICAL"
    
    var model = WordGuess()
    model.updateGuess(firstGuess)
    firstGuess.enumerated().forEach { index, character in
      let letterGuess = model.guess(at: index)
      XCTAssertEqual(String(letterGuess!.letter), String(character))
      XCTAssertEqual(letterGuess!.state, .unchecked)
    }
    
    model.updateGuess(secondGuess)
    secondGuess.enumerated().forEach { index, character in
      let letterGuess = model.guess(at: index)
      XCTAssertEqual(String(letterGuess!.letter), String(character))
      XCTAssertEqual(letterGuess!.state, .unchecked)
    }
  }
  
  func testGetGuessAtNegativeIndexIsNil() {
    var model = WordGuess()
    model.updateGuess("DIFFS")
    XCTAssertNil(model.guess(at: -1))
  }
  
  func testGetGuessAtIndexOverCountIsNil() {
    var model = WordGuess()
    model.updateGuess("DIPPY")
    XCTAssertNil(model.guess(at: 5))
  }
  
  func testGetGuessAtFirstLetterIsValid() {
    var model = WordGuess()
    model.updateGuess("CORES")
    let guess = model.guess(at: 0)!
    XCTAssertEqual(guess.letter, "C")
    XCTAssertEqual(guess.state, .unchecked)
  }
  
  func testStringRepresentationOfEmptyGuessIsEmpty() {
    var model = WordGuess()
    XCTAssertEqual(model.asString(), "")
  }
  
  func testStringRepresentationForAllStates() {
    var model = WordGuess()
    model.updateGuess("WORDS")
    model.forceState(.unchecked)
    
    XCTAssertEqual(model.asString(), "⬛️⬛️⬛️⬛️⬛️")
    
    model.forceState(.misplaced)
    
    XCTAssertEqual(model.asString(), "🟨🟨🟨🟨🟨")
    
    model.forceState(.correct)
    
    XCTAssertEqual(model.asString(), "🟩🟩🟩🟩🟩")
    
    model.forceState(.invalid)
    
    XCTAssertEqual(model.asString(), "🟥🟥🟥🟥🟥")
    
    model.forceState(.incorrect)
    
    XCTAssertEqual(model.asString(), "⬜️⬜️⬜️⬜️⬜️")
  }
}

extension WordGuessTests {
  func validateGuess(_ guess: String, against actualWord: String, pattern: [LetterState]) {
    assert(guess.count == actualWord.count, "Guess and actual word must be same length")
    assert(actualWord.count == pattern.count, "Expected pattern must be same length as actual word")
    
    var model = WordGuess()
    model.updateGuess(guess)
    let _ = model.checkGuess(against: actualWord)
    
    (0..<actualWord.count).forEach { index in
      let letterGuess = model.guess(at: index)!
      let expectedState = pattern[index]
      XCTAssertEqual(letterGuess.state, expectedState,
                     "Mismatch: expected letter \"\(letterGuess.letter)\" at index \(index) to be \(expectedState), was instead \(letterGuess.state)")
    }
  }
}
