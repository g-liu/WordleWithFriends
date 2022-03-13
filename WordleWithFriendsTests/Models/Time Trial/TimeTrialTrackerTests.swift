//
//  TimeTrialTrackerTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/13/22.
//

import XCTest
@testable import WordleWithFriends

final class TimeTrialTrackerTests: XCTestCase {
  override class func setUp() {
    super.setUp()
    
//    let bundle = Bundle(for: type(of: self))
//    let path = bundle.path(forResource: "TimeTrialTrackerTestsData", ofType: "csv")!
//    
//    do {
//      
//    }
  }
  
  func testTrackerWithEmptyActions() {
    let tracker = TimeTrialTracker(initialTimeRemaining: 300)
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 0)
    XCTAssertEqual(stats.averageTimePerClue, 0)
    
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerClue, 0)
    
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.guessCount, 0)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.guessCount, 0)
    
    XCTAssertEqual(stats.fastestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.fastestGuessForCompletedClue.timeElapsed, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.slowestGuessForCompletedClue.timeElapsed, 0)
    
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 0)
    XCTAssertEqual(stats.totalClues, 0)
    XCTAssertEqual(stats.percentCompleted, 0)
    XCTAssertEqual(stats.totalGuesses, 0)
    
    // TODO: TEST PERSONAL BEST AFTER INJECTION
  }
  
  func testTrackerWithSingleSkipAction() {
    var tracker = TimeTrialTracker(initialTimeRemaining: 300)
    tracker.logClueGuess(timeRemaining: 297.5, outcome: .skipped("SKIPS"))
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 2.5)
    XCTAssertEqual(stats.averageTimePerClue, 2.5)
    
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerClue, 0)
    
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.guessCount, 0)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.guessCount, 0)
    
    XCTAssertEqual(stats.fastestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.fastestGuessForCompletedClue.timeElapsed, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.slowestGuessForCompletedClue.timeElapsed, 0)
    
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 1)
    XCTAssertEqual(stats.totalClues, 1)
    XCTAssertEqual(stats.percentCompleted, 0)
    XCTAssertEqual(stats.totalGuesses, 0)
  }
  
  func testTrackerWithSingleIncorrectGuessAction() {
    var tracker = TimeTrialTracker(initialTimeRemaining: 300)
    tracker.logClueGuess(timeRemaining: 182, outcome: .incorrect("WRONG"))
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 118)
    XCTAssertEqual(stats.averageTimePerClue, 118)
    
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 1)
    XCTAssertEqual(stats.averageGuessesPerClue, 1)
    
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.guessCount, 0)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.guessCount, 0)
    
    XCTAssertEqual(stats.fastestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.fastestGuessForCompletedClue.timeElapsed, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.slowestGuessForCompletedClue.timeElapsed, 0)
    
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 1)
    XCTAssertEqual(stats.totalClues, 1)
    XCTAssertEqual(stats.percentCompleted, 0)
    XCTAssertEqual(stats.totalGuesses, 1)
  }
  
  func testTrackerWithSingleCorrectGuessAction() {
    var tracker = TimeTrialTracker(initialTimeRemaining: 300)
    tracker.logClueGuess(timeRemaining: 274.3, outcome: .correct("RIGHT"))
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 25.7, accuracy: 1E-7)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 0)
    XCTAssertEqual(stats.averageTimePerClue, 25.7, accuracy: 1E-7)
    
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 1)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerClue, 1)
    
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.clue, "RIGHT")
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.guessCount, 1)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.clue, "RIGHT")
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.guessCount, 1)
    
    XCTAssertEqual(stats.fastestGuessForCompletedClue.clue, "RIGHT")
    XCTAssertEqual(stats.fastestGuessForCompletedClue.timeElapsed, 25.7, accuracy: 1E-10)
    XCTAssertEqual(stats.slowestGuessForCompletedClue.clue, "RIGHT")
    XCTAssertEqual(stats.slowestGuessForCompletedClue.timeElapsed, 25.7, accuracy: 1E-10)
    
    XCTAssertEqual(stats.numCompletedClues, 1)
    XCTAssertEqual(stats.numSkippedClues, 0)
    XCTAssertEqual(stats.totalClues, 1)
    XCTAssertEqual(stats.percentCompleted, 100)
    XCTAssertEqual(stats.totalGuesses, 1)
  }
  
  func testTrackerWithMultipleIncorrectGuesses() {
    var tracker = TimeTrialTracker(initialTimeRemaining: 300)
    tracker.logClueGuess(timeRemaining: 294, outcome: .incorrect("WRONG"))
    tracker.logClueGuess(timeRemaining: 290, outcome: .incorrect("WRONG"))
    tracker.logClueGuess(timeRemaining: 287.5, outcome: .incorrect("WRONG"))
    tracker.logClueGuess(timeRemaining: 277.6, outcome: .incorrect("WRONG"))
    tracker.logClueGuess(timeRemaining: 223.9, outcome: .incorrect("WRONG"))
    
    let stats = tracker.statistics
    XCTAssertEqual(stats.averageTimePerCompletedClue, 0)
    XCTAssertEqual(stats.averageTimePerSkippedClue, 76.1)
    XCTAssertEqual(stats.averageTimePerClue, 76.1)
    
    XCTAssertEqual(stats.averageGuessesPerCompletedClue, 0)
    XCTAssertEqual(stats.averageGuessesPerSkippedClue, 5)
    XCTAssertEqual(stats.averageGuessesPerClue, 5)
    
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.lowestGuessCountForCompletedClue.guessCount, 0)
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.clue, "")
    XCTAssertEqual(stats.highestGuessCountForCompletedClue.guessCount, 0)
    
    XCTAssertEqual(stats.fastestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.fastestGuessForCompletedClue.timeElapsed, 0)
    XCTAssertEqual(stats.slowestGuessForCompletedClue.clue, "")
    XCTAssertEqual(stats.slowestGuessForCompletedClue.timeElapsed, 0)
    
    XCTAssertEqual(stats.numCompletedClues, 0)
    XCTAssertEqual(stats.numSkippedClues, 1)
    XCTAssertEqual(stats.totalClues, 1)
    XCTAssertEqual(stats.percentCompleted, 0)
    XCTAssertEqual(stats.totalGuesses, 5)
  }
  
}
