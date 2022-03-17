//
//  String+Extension_Tests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/15/22.
//

import Foundation
@testable import WordleWithFriends
import XCTest

final class StringExtensionTests: XCTestCase {
  func testSubstringToString() {
    let word = "extraordinary"
    XCTAssertEqual(word[0...4].asString, "extra")
  }
  
  func testIsLettersOnlyEmptyString() {
    XCTAssert("".isLettersOnly)
  }
  
  func testIsLettersOnlyOnNumericString() {
    XCTAssertFalse("313783942".isLettersOnly)
  }
  
  func testIsLettersOnlyOnStringWithSpaces() {
    XCTAssertFalse("There lay".isLettersOnly)
  }
  
  func testIsLettersOnlyOnHyphenatedString() {
    XCTAssertFalse("absent-minded".isLettersOnly)
  }
  
  func testIsLettersOnlyOnStringWithSymbols() {
    XCTAssertFalse("©thirdinversion".isLettersOnly)
  }
  
  func testIsLettersOnlyMixWithNumbers() {
    XCTAssertFalse("AccessibilityEqualsA11y".isLettersOnly)
  }
  
  func testIsLettersOnlyAllLowercase() {
    XCTAssert("birdsarentreal".isLettersOnly)
  }
  
  func testIsLettersOnlyAllUppercase() {
    XCTAssert("YESTHEYARE".isLettersOnly)
  }
  
  func testIsLettersOnlyMixedCase() {
    XCTAssert("FirstWeMustSeeThat".isLettersOnly)
  }
  
  func testIsLettersOnlyWithDiacritics() {
    XCTAssert("NaïveFlèche".isLettersOnly)
  }
}
