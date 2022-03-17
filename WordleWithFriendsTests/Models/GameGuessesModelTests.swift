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
    let model = GameGuessesModel(clue: "GOOSE", gamemode: .human)
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
    XCTAssertNil(GameGuessesModel(clue: "COOKS", gamemode: .human).mostRecentGuess)
  }
  
  func testMostRecentGuessWhenIncompleteGuessExists() {
    var model = GameGuessesModel(clue: "COOKS", gamemode: .human)
    model.updateGuess("CORKS")
    XCTAssertNil(model.mostRecentGuess)
  }
  
  func testMostRecentGuessWhenOneCompleteGuessExists() {
    var model = GameGuessesModel(clue: "COOKS", gamemode: .human)
    model.updateGuess("CORKS")
    model.submitGuess()
    
    XCTAssertEqual(model.mostRecentGuess?.word, "CORKS")
  }
  
  func testSubmitGuessNotLongEnoughGuess() {
    var model = GameGuessesModel(clue: "COOKS", gamemode: .human)
    model.updateGuess("COOK")
    let result = model.submitGuess()
    
    XCTAssertEqual(result, .invalidLength)
  }
  
  func testSubmitGuessTooLongGuess() {
    var model = GameGuessesModel(clue: "COOKS", gamemode: .human)
    model.updateGuess("COOKER")
    let result = model.submitGuess()
    
    XCTAssertEqual(result, .invalidLength)
  }
}
