//
//  WordGuessTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 1/14/22.
//

import XCTest
@testable import WordleWithFriends

class WordGuessTests: XCTestCase {
  // MARK: - word
  func testWordFromEmptyGuess() {
    XCTAssertEqual(WordGuess().word, "")
  }
  
  func testWordFromNonEmptyGuess() {
    XCTAssertEqual(WordGuess(guess: "FIRST").word, "FIRST")
  }
  
  // MARK: - checkGuess
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
  
  func testMoreMisplacedLettersThanPresentInClue() {
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
    var model = WordGuess(guess: guess)
    model.forceState(.misplaced)
    (0..<guess.count).forEach { index in
      XCTAssertEqual(model.guess(at: index)?.state, .misplaced)
    }
  }
  
  func testUpdateGuessToDifferentLength() {
    let firstGuess = "DOPES"
    let secondGuess = "MAGICAL"
    
    var model = WordGuess(guess: firstGuess)
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
    let model = WordGuess(guess: "DIFFS")
    XCTAssertNil(model.guess(at: -1))
  }
  
  func testGetGuessAtIndexOverCountIsNil() {
    let model = WordGuess(guess: "DIPPY")
    XCTAssertNil(model.guess(at: 5))
  }
  
  func testGetGuessAtFirstLetterIsValid() {
    let model = WordGuess(guess: "CORES")
    let guess = model.guess(at: 0)!
    XCTAssertEqual(guess.letter, "C")
    XCTAssertEqual(guess.state, .unchecked)
  }
  
  func testStringRepresentationOfEmptyGuessIsEmpty() {
    let model = WordGuess()
    XCTAssertEqual(model.asString(), "")
  }
  
  func testStringRepresentationForAllStates() {
    var model = WordGuess(guess: "WORDS")
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
  func validateGuess(_ guess: String, against clue: String, pattern: [LetterState]) {
    assert(guess.count == clue.count, "Guess and clue must be same length")
    assert(clue.count == pattern.count, "Expected pattern must be same length as clue")
    
    var model = WordGuess(guess: guess)
    let _ = model.checkGuess(against: clue)
    
    (0..<clue.count).forEach { index in
      let letterGuess = model.guess(at: index)!
      let expectedState = pattern[index]
      XCTAssertEqual(letterGuess.state, expectedState,
                     "Mismatch: expected letter \"\(letterGuess.letter)\" at index \(index) to be \(expectedState), was instead \(letterGuess.state)")
    }
  }
}
