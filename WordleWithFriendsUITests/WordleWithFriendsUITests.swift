//
//  WordleWithFriendsUITests.swift
//  WordleWithFriendsUITests
//
//  Created by Geoffrey Liu on 1/14/22.
//

import XCTest
@testable import WordleWithFriends

final class WordleWithFriendsUITests: XCTestCase {
  private let app = XCUIApplication()
  
  func testSettingsPresent() {
    app.launch()
    app.navigationBars.buttons.firstMatch.tap()
    
    XCTAssert(app.navigationBars["Settings"].staticTexts["Settings"].waitForExistence(timeout: 3))
    
    let settingsTable = app.tables
    
    // TODO WTF?????
//    GameSettings.allSettings.forEach {
//      XCTAssert(settingsTable.cells.staticTexts[$0.description].exists)
//    }
  }
  
  func testClueInputValidation() {
    app.launch()
    let clueTextField = app.textFields["GameSetupViewController.clueTextField"]
    let _ = clueTextField.waitForExistence(timeout: 3)
    clueTextField.typeText("FLAN\n")
    XCTAssert(app.alerts["Error"].waitForExistence(timeout: 3))
    XCTAssert(app.alerts.staticTexts["Your word is not long enough."].exists)
    
    app.alerts.buttons["Ok"].tap()
    
    clueTextField.clearText()
    clueTextField.typeText("HGHGH\n")
    
    XCTAssert(app.alerts["Error"].waitForExistence(timeout: 3))
    app.alerts.buttons["Ok"].tap()
  }
}
