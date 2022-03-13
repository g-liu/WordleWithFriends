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
    let tracker = TimeTrialTracker(initialTimeRemaining: 300)
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 0)
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue, 0)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue, 0)
    XCTAssertEqual(stats.fastestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 0)
    XCTAssertEqual(stats.totalGuesses, 0)
  }
  
  func testTrackerWithSingleSkipAction() {
    var tracker = TimeTrialTracker(initialTimeRemaining: 300)
    tracker.logClueGuess(timeRemaining: 297.5, outcome: .skipped)
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 2.5)
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 1)
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue, 0)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue, 0)
    XCTAssertEqual(stats.fastestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 1)
    XCTAssertEqual(stats.totalGuesses, 1)
  }
}
