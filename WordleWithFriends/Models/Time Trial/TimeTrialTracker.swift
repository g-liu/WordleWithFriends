//
//  TimeTrialTracker.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/12/22.
//

import Foundation

struct TimeTrialTracker {
  private var guessActions: [GuessAction] = .init() {
    didSet {
      if numCompletedClues > highScore {
        highScore = numCompletedClues
      }
    }
  }
  
  private let initialTimeRemaining: TimeInterval
  
  init(initialTimeRemaining: TimeInterval) {
    self.initialTimeRemaining = initialTimeRemaining
  }
  
  var personalBest = UserDefaults.standard.integer(forKey: "gameStats.highScore") // TODO: INJECT FOR TESTING???
  
  var statistics: GameStatistics {
    .init(averageTimePerCompletedClue: averageTimePerCorrectClue,
          averageTimePerSkippedClue: averageTimePerSkippedClue,
          averageGuessesPerCompletedClue: averageGuessesPerCorrectClue,
          averageGuessesPerSkippedClue: averageGuessesPerSkippedClue,
          lowestGuessCountForCompletedClue: lowestGuessCountForCorrectClue,
          highestGuessCountForCompletedClue: highestGuessCountForCorrectClue,
          fastestGuessForCompletedClue: fastestGuessForCompletedClue,
          slowestGuessForCompletedClue: slowestGuessForCompletedClue,
          completedClues: completedClues,
          skippedClues: skippedClues,
//          numCompletedClues: numCompletedClues,
//          numSkippedClues: numSkippedClues,
          totalGuesses: totalGuesses,
          personalBest: personalBest)
  }
  
  var numCompletedClues: Int {
    correctClueAttempts.count
  }
  
  var completedClues: [String] {
    attemptsPerClue.compactMap {
      guard case .correct(let guess) = $0.outcome else { return nil }
      return guess
    }
  }
  
  var skippedClues: [String] {
    // TODO: DOES NOT ACCOUNT FOR LAST CLUE WHEN TIME EXPIRES!!!!
    attemptsPerClue.compactMap {
      guard case .skipped(let actualClue) = $0.outcome else { return nil }
      return actualClue
    }
  }
  
  private var numSkippedClues: Int {
    skippedClueAttempts.count
  }
  
  var numGivenClues: Int {
    attemptsPerClue.count
  }
  
  private var totalGuesses: Int {
    guessActions.filter { !$0.outcome.isComparable(to: .skipped()) }.count
  }
  
  private var averageTimePerCorrectClue: Double {
    guard numCompletedClues > 0 else { return 0 }
    
    let totalTimeTaken = correctClueAttempts.reduce(0) { $0 + $1.totalTimeElapsed }
    
    return totalTimeTaken / numCompletedClues
  }
  
  private var averageTimePerSkippedClue: Double {
    guard numSkippedClues > 0 else { return 0 }
    
    let totalTimeTaken = skippedClueAttempts.reduce(0) { $0 + $1.totalTimeElapsed }
    
    return totalTimeTaken / numSkippedClues
  }
  
  private var averageGuessesPerCorrectClue: Double {
    guard numCompletedClues > 0 else { return 0.0 }
    
    let totalGuessesTaken = correctClueAttempts.reduce(0.0) { $0 + $1.numGuesses }
    
    return totalGuessesTaken / numCompletedClues
  }
  
  private var averageGuessesPerSkippedClue: Double {
    guard numSkippedClues > 0 else { return 0.0 }
    
    let totalGuessesTaken = skippedClueAttempts.reduce(0.0) { $0 + $1.numGuesses }
    
    return totalGuessesTaken / numSkippedClues
  }
  
  private var lowestGuessCountForCorrectClue: (String, Int) {
    guard let min = correctClueAttempts.min(by: { $0.numGuesses < $1.numGuesses }),
          case .correct(let guess) = min.outcome else { return ("", 0) }
    
    return (guess, min.numGuesses)
  }
  
  private var highestGuessCountForCorrectClue: (String, Int) {
    guard let max = correctClueAttempts.max(by: { $0.numGuesses < $1.numGuesses }),
          case .correct(let guess) = max.outcome else { return ("", 0) }
    
    return (guess, max.numGuesses)
  }
  
  private var fastestGuessForCompletedClue: (String, TimeInterval) {
    guard let min = correctClueAttempts.min(by: { $0.totalTimeElapsed < $1.totalTimeElapsed }),
          case .correct(let guess) = min.outcome else { return ("", 0) }
    
    return (guess, min.totalTimeElapsed)
  }
  
  private var slowestGuessForCompletedClue: (String, TimeInterval) {
    guard let max = correctClueAttempts.max(by: { $0.totalTimeElapsed < $1.totalTimeElapsed }),
          case .correct(let guess) = max.outcome else { return ("", 0) }
    
    return (guess, max.totalTimeElapsed)
  }
  
  private var attemptsPerClue: [ClueAttempt] {
    let result1 = guessActions.splitIncludeDelimiter { action in
      action.outcome.isComparable(to: .correct()) || action.outcome.isComparable(to: .skipped())
    }
    
    let result2 = result1.enumerated().compactMap { index, actionsPerClue -> ClueAttempt? in
      guard let timeOfFirstGuess = actionsPerClue.first?.timeRemaining,
            let timeOfLastGuess = actionsPerClue.last?.timeRemaining,
            let outcome = actionsPerClue.last?.outcome else { return nil }
  
      let totalTimeElapsed = index == 0 ? initialTimeRemaining - timeOfLastGuess : timeOfFirstGuess - timeOfLastGuess
      // A skip in and of itself does not count as a guess. The attempts before it will be counted in the number of guesses.
      let numGuesses = outcome.isComparable(to: .skipped()) ? actionsPerClue.count - 1 : actionsPerClue.count
      
      return .init(numGuesses: numGuesses, outcome: outcome, totalTimeElapsed: totalTimeElapsed)
    }
    
    return result2
  }
  
  private var correctClueAttempts: [ClueAttempt] {
    attemptsPerClue.filter { $0.outcome.isComparable(to: .correct()) }
  }
  
  private var skippedClueAttempts: [ClueAttempt] {
    // Note: Incorrect attempts only occur when timer expires, and are counted as a skip.
    attemptsPerClue.filter { $0.outcome.isComparable(to: .skipped()) || $0.outcome.isComparable(to: .incorrect()) }
  }
  
  private(set) var highScore: Int {
    get { UserDefaults.standard.integer(forKey: "gameStats.highScore") }
    set {
      UserDefaults.standard.set(newValue, forKey: "gameStats.highScore")
    }
  }
  
  var isPersonalBest: Bool { highScore > personalBest }
  
  mutating func logClueGuess(timeRemaining: TimeInterval, outcome: GuessOutcome) {
    guessActions.append(.init(timeRemaining: timeRemaining, outcome: outcome))
  }
}

struct ClueAttempt {
  let numGuesses: Int
  let outcome: GuessOutcome
  let totalTimeElapsed: TimeInterval
}

enum GuessOutcome {
  case correct(_ guess: String = "")
  case incorrect(_ guess: String = "") /* TODO: SHOULD BE ACTUAL CLUE?? */
  case skipped(_ actualClue: String = "")
  
  func isComparable(to otherOutcome: GuessOutcome) -> Bool {
    switch (self, otherOutcome) {
      case (.correct(_), .correct(_)),
        (.incorrect(_), .incorrect(_)),
        (.skipped(_), .skipped(_)):
        return true
      default:
        return false
    }
  }
}

struct GuessAction {
  let timeRemaining: TimeInterval
  let outcome: GuessOutcome
}
