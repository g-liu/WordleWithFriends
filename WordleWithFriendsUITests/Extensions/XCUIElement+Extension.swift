//
//  XCUIElement+Extension.swift
//  WordleWithFriendsUITests
//
//  Created by Geoffrey Liu on 1/18/22.
//

import XCTest

extension XCUIElement {
  func clearText() {
    guard let stringValue = self.value as? String else {
      XCTFail("Tried to clear and enter text into a non string value")
      return
    }
    
    self.tap()
    
    let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
    
    self.typeText(deleteString)
  }
}
