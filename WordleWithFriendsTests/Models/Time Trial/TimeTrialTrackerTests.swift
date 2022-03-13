//
//  TimeTrialTrackerTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/13/22.
//

import XCTest
@testable import WordleWithFriends

// TODO: TEST DERIVED VARIABLES TOO
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
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 0)
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue, 0)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue, 0)
    XCTAssertEqual(stats.fastestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue, 0)
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 1)
    XCTAssertEqual(stats.totalGuesses, 0)
  }
  
  func testTrackerWithSingleIncorrectGuessAction() {
    var tracker = TimeTrialTracker(initialTimeRemaining: 300)
    tracker.logClueGuess(timeRemaining: 182, outcome: .incorrect)
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 118)
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
  
  func testTrackerWithSingleCorrectGuessAction() {
    var tracker = TimeTrialTracker(initialTimeRemaining: 300)
    tracker.logClueGuess(timeRemaining: 274.3, outcome: .correct)
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 25.7, accuracy: 1E-7)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 1)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 0)
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue, 1)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue, 1)
    XCTAssertEqual(stats.fastestGuessForCompletedClue, 25.7, accuracy: 1E-7)
    XCTAssertEqual(stats.slowestGuessForCompletedClue, 25.7, accuracy: 1E-7)
    XCTAssertEqual(stats.numCompletedClues, 1)
    XCTAssertEqual(stats.numSkippedClues, 0)
    XCTAssertEqual(stats.totalGuesses, 1)
  }
}
