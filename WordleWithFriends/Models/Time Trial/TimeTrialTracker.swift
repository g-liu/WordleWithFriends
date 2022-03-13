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
  
  var personalBest = UserDefaults.standard.integer(forKey: "gameStats.highScore")
  
  var statistics: GameStatistics {
    .init(averageTimePerCompletedClue: averageTimePerCorrectClue,
          averageTimePerSkippedClue: averageTimePerSkippedClue,
          averageGuessesPerCompletedClue: averageGuessesPerCorrectClue,
          averageGuessesPerSkippedClue: averageGuessesPerSkippedClue,
          lowestGuessCountForCompletedClue: lowestGuessCountForCorrectClue,
          highestGuessCountForCompletedClue: highestGuessCountForCorrectClue,
          fastestGuessForCompletedClue: fastestGuessForCompletedClue,
          slowestGuessForCompletedClue: slowestGuessForCompletedClue,
          numCompletedClues: numCompletedClues,
          numSkippedClues: numSkippedClues,
          totalGuesses: totalGuesses,
          personalBest: personalBest)
  }
  
  var numCompletedClues: Int {
    correctClueAttempts.count
  }
  
  private var numSkippedClues: Int {
    skippedClueAttempts.count
  }
  
  var numGivenClues: Int {
    attemptsPerClue.count
  }
  
  private var totalGuesses: Int {
    guessActions.filter { $0.outcome != .skipped }.count
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
  
  private var lowestGuessCountForCorrectClue: Int {
    guard let min = correctClueAttempts.min(by: { $0.numGuesses < $1.numGuesses }) else { return 0 }
    
    return min.numGuesses
  }
  
  private var highestGuessCountForCorrectClue: Int {
    guard let max = correctClueAttempts.max(by: { $0.numGuesses < $1.numGuesses }) else { return 0 }
    
    return max.numGuesses
  }
  
  private var fastestGuessForCompletedClue: TimeInterval {
    guard let min = correctClueAttempts.min(by: { $0.totalTimeElapsed < $1.totalTimeElapsed }) else { return 0 }
    
    return min.totalTimeElapsed
  }
  
  private var slowestGuessForCompletedClue: TimeInterval {
    guard let max = correctClueAttempts.max(by: { $0.totalTimeElapsed < $1.totalTimeElapsed }) else { return 0 }
    
    return max.totalTimeElapsed
  }
  
  private var attemptsPerClue: [ClueAttempt] {
    let result1 = guessActions.splitIncludeDelimiter { action in
      action.outcome == .correct || action.outcome == .skipped
    }
    
    let result2 = result1.compactMap { actionsPerClue -> ClueAttempt? in
      guard let timeOfFirstGuess = actionsPerClue.first?.timeRemaining,
            let timeOfLastGuess = actionsPerClue.last?.timeRemaining,
            let outcome = actionsPerClue.last?.outcome else { return nil }
  
      let totalTimeElapsed = timeOfFirstGuess - timeOfLastGuess
      // A skip in and of itself does not count as a guess. The attempts before it will be counted in the number of guesses.
      let numGuesses = outcome == .skipped ? actionsPerClue.count - 1 : actionsPerClue.count
      
      return .init(numGuesses: numGuesses, outcome: outcome, totalTimeElapsed: totalTimeElapsed)
    }
    
    return result2
  }
  
  private var correctClueAttempts: [ClueAttempt] {
    attemptsPerClue.filter { $0.outcome == .correct }
  }
  
  private var skippedClueAttempts: [ClueAttempt] {
    // Note: Incorrect attempts only occur when timer expires, and are counted as a skip.
    attemptsPerClue.filter { $0.outcome == .skipped || $0.outcome == .incorrect }
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
  case correct
  case incorrect
  case skipped
}

struct GuessAction {
  let timeRemaining: TimeInterval
  let outcome: GuessOutcome
}
