//
//  Array+Extension_Tests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/15/22.
//

import XCTest
@testable import WordleWithFriends

final class ArrayExtensionTests: XCTestCase {
  func testSplitWithDelimiterOnEmptyArray() {
    let stringArray: [String] = []
    let result = stringArray.splitIncludeDelimiter { $0 == "," }
    
    XCTAssertEqual(result, [[]])
  }
  
  func testSplitWithArrayContainingNoDelimiters() {
    let array: [Int] = [3, 2, 5, 4, 88, 89]
    let result = array.splitIncludeDelimiter { $0 < 0 }
    
    XCTAssertEqual(result[0], array)
    XCTAssertEqual(result.count, 1)
  }
  
  func testSplitWithDelimiterAsFirstElement() {
    let array: [GuessOutcome] = [.skipped, .incorrect(guess: ""), .incorrect(guess: ""), .incorrect(guess: ""), .endGame]
    let result = array.splitIncludeDelimiter { $0 == .skipped }
    
    XCTAssertEqual(result[0], [array.first])
    XCTAssertEqual(result[1], array.rest)
    XCTAssertEqual(result.count, 2)
  }
  
  func testSplitWithDelimiterAsLastElement() {
    let array: [Int] = [0, 0, 0, 0, 10, 20, 50, 9]
    let result = array.splitIncludeDelimiter { $0 % 10 != 0 }
    
    XCTAssertEqual(result[0], array)
    XCTAssertEqual(result.count, 1)
  }
  
  func testSplitWithConsecutiveDelimiters() {
    let array: [Int] = [0, 0, 0, 0, 0, 0]
    let result = array.splitIncludeDelimiter { $0 == 0 }
    
    XCTAssertEqual(result.count, 6)
    (0..<result.count).forEach {
      XCTAssertEqual(result[$0], [0])
    }
  }
  
  func testSplitWithDelimiterInMultiplePlaces() {
    let array: [Int] = [0, 5, 6, 7, 0, 4, 3, 32, 0, 4, 0, 0, 8, 0]
    let result = array.splitIncludeDelimiter { $0 == 0 }
    
    XCTAssertEqual(result, [[0], [5,6,7,0], [4,3,32,0], [4,0], [0], [8, 0]])
  }
  
  func testInvariantOfEachLastElementIsDelimiter() {
    let array: [Int] = (0..<25).map { _ in .random(in: 0...10) }
    let result = array.splitIncludeDelimiter { $0 == 0 }
    
    guard result.count >= 2 else { return }
    (0..<result.count-1).forEach {
      XCTAssertEqual(result[$0].last, 0)
    }
  }
}
