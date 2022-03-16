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
  var csvData: CSV! // TODO: ALL TEST DATA TO ACCOUNT FOR END OF GAME!!!!
  
  override func setUpWithError() throws { /* I would make this static but we need to access the instance property */
    super.setUp()
    
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "TimeTrialTrackerTestsData", ofType: "csv")!
    let csv = try CSV(url: .init(fileURLWithPath: path))
    csvData = csv
  }
  
  func testRunTestFromData() {
    csvData.namedRows.enumerated().forEach { index, row in
      let testName = row["testName"]!
      XCTContext.runActivity(named: "test\(testName)") { activity in
        guard let initialTimeString = row["initialTime"],
              !initialTimeString.isEmpty,
              let initialTime = initialTimeString.asTimeInterval else { return }
        
        var tracker = TimeTrialTracker(initialTimeRemaining: initialTime)
        tracker.insertGuesses(from: row["guessLog"]!)
        
        let stats = tracker.statistics
        
        XCTAssertEqual(row["avgTimePerCompleted"]!.asTimeInterval!, stats.averageTimePerCompletedClue, accuracy: 1E-10, "Discrepancy in average time per completed clue")
        XCTAssertEqual(row["avgTimePerSkipped"]!.asTimeInterval!, stats.averageTimePerSkippedClue, accuracy: 1E-10, "Discrepancy in average time per skipped clue")
        XCTAssertEqual(row["avgTimePerClue"]!.asTimeInterval!, stats.averageTimePerClue, accuracy: 1E-10, "Discrepancy in average time per clue")
    
        XCTAssertEqual(row["avgGuessesPerCompleted"]!.asDouble!, stats.averageGuessesPerCompletedClue, accuracy: 1E-10, "Discrepancy in average guesses per completed clue")
        XCTAssertEqual(row["avgGuessesPerSkipped"]!.asDouble!, stats.averageGuessesPerSkippedClue, accuracy: 1E-10, "Discrepancy in average guesses per skipped clue")
        XCTAssertEqual(row["avgGuessesPerClue"]!.asDouble!, stats.averageGuessesPerClue, accuracy: 1E-10, "Discrepancy in average guesses per clue")
    
        XCTAssertEqual(row["lowestGuessCountClue"], stats.lowestGuessCountForCompletedClue.clue, "Discrepancy in the clue that had the lowest guess count")
        XCTAssertEqual(row["lowestGuessCountCount"]!.asInt!, stats.lowestGuessCountForCompletedClue.guessCount, "Discrepancy in number of guesses taken for the clue with the lowest guess count")
        XCTAssertEqual(row["highestGuessCountClue"], stats.highestGuessCountForCompletedClue.clue, "Discrepancy in the clue that had the lowest guess count")
        XCTAssertEqual(row["highestGuessCountCount"]!.asInt!, stats.highestGuessCountForCompletedClue.guessCount,  "Discrepancy in number of guesses taken for the clue with the highest guess count")
    
        XCTAssertEqual(row["fastestGuessClue"], stats.fastestGuessForCompletedClue.clue, "Discrepancy in the clue that was guessed the fastest")
        XCTAssertEqual(row["fastestGuessTimeElapsed"]!.asTimeInterval!, stats.fastestGuessForCompletedClue.timeElapsed, accuracy: 1E-10, "Discrepancy in the time elapsed for the clue guessed the fastest")
        XCTAssertEqual(row["slowestGuessClue"], stats.slowestGuessForCompletedClue.clue, "Discrepancy in the clue that was guessed the fastest")
        XCTAssertEqual(row["slowestGuessTimeElapsed"]!.asTimeInterval!, stats.slowestGuessForCompletedClue.timeElapsed, accuracy: 1E-10, "Discrepancy in the time elapsed for the clue guessed the fastest")
    
        XCTAssertEqual(row["numCompletedClues"]!.asInt!, stats.numCompletedClues, "Discrepancy in the number of completed clues")
        XCTAssertEqual(row["numSkippedClues"]!.asInt!, stats.numSkippedClues, "Discrepancy in the number of skipped clues")
        XCTAssertEqual(row["totalClues"]!.asInt!, stats.totalClues, "Discrepancy in the total number of clues given")
        XCTAssertEqual(row["percentCompleted"]!.asDouble!, stats.percentCompleted, accuracy: 1E-10, "Discrepancy in the percentage of given clues completed")
        XCTAssertEqual(row["totalGuesses"]!.asInt!, stats.totalGuesses, "Discrepancy in the total number of guesses taken")
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
          case "i": return .incorrect(guess: "XXXXX") // TODO: Assoc. value not tested yet
          case "s": return .skipped
          case "c": return .correct
          case "e": return .endGame
          default:
            XCTFail("Used an invalid code in the guess log: \(outcomeCode)")
            return nil
        }
      }()
      
      logAction(timeRemaining: timeRemaining, outcome: outcome!, actualClue: actualClue)
    }
  }
}
