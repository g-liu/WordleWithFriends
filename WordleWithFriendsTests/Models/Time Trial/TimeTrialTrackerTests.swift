//
//  TimeTrialTrackerTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/13/22.
//

import XCTest
@testable import WordleWithFriends

final class TimeTrialTrackerTests: XCTestCase {
  func testTrackerWithEmptyActions() {
    let tracker = TimeTrialTracker()
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 0)
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue, 0)
    XCTAssertEqual(stats.fastestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 0)
    XCTAssertEqual(stats.totalGuesses, 0)
    
    
  }
}
