//
//  TimeTrialTrackerTests.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/13/22.
//

import XCTest
import SwiftCSV
@testable import WordleWithFriends

final class TimeTrialTrackerTests: XCTestCase {
  var csvData: CSV!
  
  override func setUpWithError() throws { /* TODO: I would make this static but we need to access the instance property */
    super.setUp()
    
    
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "TimeTrialTrackerTestsData", ofType: "csv")!
    let csv = try CSV(url: .init(fileURLWithPath: path))
    csvData = csv
  }
  
  func testRunTestFromData() {
    csvData.namedRows.enumerated().forEach { index, row in
      let testName = row["testName"]!
      XCTContext.runActivity(named: testName) { activity in
        let initialTime = row["initialTime"]!.asTimeInterval!
        var tracker = TimeTrialTracker(initialTimeRemaining: initialTime)
        tracker.insertGuesses(from: row["guessLog"]!)
        
        let stats = tracker.statistics
        
        XCTAssertEqual(stats.averageTimePerCompletedClue, row["avgTimePerCompleted"]!.asTimeInterval!, accuracy: 1E-10)
        XCTAssertEqual(stats.averageTimePerSkippedClue, row["avgTimePerSkipped"]!.asTimeInterval!, accuracy: 1E-10)
        XCTAssertEqual(stats.averageTimePerClue, row["avgTimePerClue"]!.asTimeInterval!, accuracy: 1E-10)
    
        XCTAssertEqual(stats.averageGuessesPerCompletedClue, row["avgGuessesPerCompleted"]!.asDouble!, accuracy: 1E-10)
        XCTAssertEqual(stats.averageGuessesPerSkippedClue, row["avgGuessesPerSkipped"]!.asDouble!, accuracy: 1E-10)
        XCTAssertEqual(stats.averageGuessesPerClue, row["avgGuessesPerClue"]!.asDouble!, accuracy: 1E-10)
    
        XCTAssertEqual(stats.lowestGuessCountForCompletedClue.clue, row["lowestGuessCountClue"])
        XCTAssertEqual(stats.lowestGuessCountForCompletedClue.guessCount, row["lowestGuessCountCount"]!.asInt)
        XCTAssertEqual(stats.highestGuessCountForCompletedClue.clue, row["highestGuessCountClue"])
        XCTAssertEqual(stats.highestGuessCountForCompletedClue.guessCount, row["highestGuessCountCount"]!.asInt)
    
        XCTAssertEqual(stats.fastestGuessForCompletedClue.clue, row["fastestGuessClue"])
        XCTAssertEqual(stats.fastestGuessForCompletedClue.timeElapsed, row["fastestGuessTimeElapsed"]!.asTimeInterval!, accuracy: 1E-10)
        XCTAssertEqual(stats.slowestGuessForCompletedClue.clue, row["slowestGuessClue"])
        XCTAssertEqual(stats.slowestGuessForCompletedClue.timeElapsed, row["slowestGuessTimeElapsed"]!.asTimeInterval!, accuracy: 1E-10)
    
        XCTAssertEqual(stats.numCompletedClues, row["numCompletedClues"]!.asInt)
        XCTAssertEqual(stats.numSkippedClues, row["numSkippedClues"]!.asInt)
        XCTAssertEqual(stats.totalClues, row["totalClues"]!.asInt)
        XCTAssertEqual(stats.percentCompleted, row["percentCompleted"]!.asDouble!, accuracy: 1E-10)
        XCTAssertEqual(stats.totalGuesses, row["totalGuesses"]!.asInt)
      }
    }
  }
}



private extension TimeTrialTracker {
  
  /// Insert multiple logs using a formatted `guessLog` string
  ///
  /// - Parameter guessLog: A formatted guess log string containing zero or more entries to log.
  /// An individual entry is formatted as "[Timestamp] [OutcomeCode][ActualClue]", where
  /// OutcomeCode is a single character representing a guess outcome as follows:
  ///   i = incorrect
  ///   s = skipped
  ///   c = correct
  /// Entries are separated by a comma
  mutating func insertGuesses(from guessLog: String) {
    let guesses = guessLog.split(separator: ",")
    guesses.forEach { guess in
      let entry = guess.split(separator: " ", maxSplits: 1)
      let timeRemaining = entry[0].asString.asTimeInterval!
      let actualClue = entry[1].dropFirst().asString.uppercased()
      let outcome: GuessOutcome? = {
        let outcomeCode = entry[1].first
        switch outcomeCode {
          case "i": return .incorrect(actualClue)
          case "s": return .skipped(actualClue)
          case "c": return .correct(actualClue)
          default:
            XCTFail("Used an invalid code in the guess log: \(outcomeCode)")
            return nil
        }
      }()
      
      logClueGuess(timeRemaining: timeRemaining, outcome: outcome!)
    }
  }
}
