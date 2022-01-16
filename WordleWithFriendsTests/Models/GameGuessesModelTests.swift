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
    let model = GameGuessesModel()
    let maxGuesses = GameSettingsModel.maxGuesses.readIntValue()
    XCTAssertEqual(model.actualWord, "")
    XCTAssertEqual(model.isGameOver, false)
    XCTAssertEqual(model.numberOfGuesses, 0)
    
    XCTAssertNotNil(model.guess(at: 0))
    XCTAssertNil(model.guess(at: 1))
    
    model.copyResult()
    XCTAssertEqual(UIPasteboard.general.string, "Wordle With Friends - 0/\(maxGuesses)\n\n")
  }
}
