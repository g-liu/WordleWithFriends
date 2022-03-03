//
//  GameGuessesModelTests.swift
//  WordleWithFriendsTests
//
//  Created by Personal on 1/15/22.
//

import XCTest
@testable import WordleWithFriends

final class GameGuessesModelTests: XCTestCase {
  func testInitialConditions() {
    let model = GameGuessesModel(clue: "GOOSE")
    let maxGuesses = GameSettings.maxGuesses.readIntValue()
    XCTAssertEqual(model.clue, "GOOSE")
    XCTAssertEqual(model.isGameOver, false)
    XCTAssertEqual(model.numberOfGuesses, 0)
    
    XCTAssertNotNil(model.guess(at: 0))
    XCTAssertNil(model.guess(at: 1))
    
    model.copyResult()
    XCTAssertEqual(UIPasteboard.general.string, "Wordle With Friends - 0/\(maxGuesses)\n\n")
  }
  
  // MARK: - mostRecentGuess
  
  func testMostRecentGuessWhenNoneExist() {
    XCTAssertNil(GameGuessesModel(clue: "COOKS").mostRecentGuess)
  }
  
  func testMostRecentGuessWhenIncompleteGuessExists() {
    var model = GameGuessesModel(clue: "COOKS")
    model.updateGuess("CORKS")
    XCTAssertNil(model.mostRecentGuess)
  }
  
  func testMostRecentGuessWhenOneCompleteGuessExists() {
    var model = GameGuessesModel(clue: "COOKS")
    model.updateGuess("CORKS")
    model.submitGuess()
    
    XCTAssertEqual(model.mostRecentGuess?.word, "CORKS")
  }
}
