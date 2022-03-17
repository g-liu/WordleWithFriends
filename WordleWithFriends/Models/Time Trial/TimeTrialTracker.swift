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
  
  var didLogEndGame: Bool { guessActions.last?.outcome == .endGame }
  
  let initialTimeRemaining: TimeInterval
  
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
          totalGuesses: totalGuesses,
          personalBest: personalBest)
  }
  
  var numCompletedClues: Int {
    correctClueAttempts.count
  }
  
  var completedClues: [String] {
    correctClueAttempts.map { $0.actualClue }
  }
  
  var skippedClues: [String] {
    skippedClueAttempts.map { $0.actualClue }
  }
  
  private var numSkippedClues: Int {
    skippedClueAttempts.count
  }
  
  var numGivenClues: Int {
    attemptsPerClue.count
  }
  
  private var totalGuesses: Int {
    guessActions.filter { $0.outcome != .skipped && $0.outcome != .endGame }.count
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
          min.outcome == .correct else { return ("", 0) }
    
    return (min.actualClue, min.numGuesses)
  }
  
  private var highestGuessCountForCorrectClue: (String, Int) {
    guard let max = correctClueAttempts.max(by: { $0.numGuesses < $1.numGuesses }),
          max.outcome == .correct else { return ("", 0) }
    
    return (max.actualClue, max.numGuesses)
  }
  
  private var fastestGuessForCompletedClue: (String, TimeInterval) {
    guard let min = correctClueAttempts.min(by: { $0.totalTimeElapsed < $1.totalTimeElapsed }),
          min.outcome == .correct else { return ("", 0) }
    
    return (min.actualClue, min.totalTimeElapsed)
  }
  
  private var slowestGuessForCompletedClue: (String, TimeInterval) {
    guard let max = correctClueAttempts.max(by: { $0.totalTimeElapsed < $1.totalTimeElapsed }),
          max.outcome == .correct else { return ("", 0) }
    
    return (max.actualClue, max.totalTimeElapsed)
  }
  
  private var attemptsPerClue: [ClueAttempt] {
    let result1 = guessActions.splitIncludeDelimiter { action in
      action.outcome == .correct || action.outcome == .skipped
    }
    
    let result2 = result1.enumerated().compactMap { index, actionsPerClue -> ClueAttempt? in
      guard let timeOfClueInitiation = index == 0 ? initialTimeRemaining : result1[index-1].last?.timeRemaining,
            let lastAction = actionsPerClue.last,
            // Don't include the end of game event by itself
            !(lastAction.outcome == .endGame && actionsPerClue.count == 1) else { return nil }
      
      let timeOfLastAction = lastAction.timeRemaining
      let lastOutcome = lastAction.outcome
  
      let totalTimeElapsed = timeOfClueInitiation - timeOfLastAction
      // A skip in and of itself does not count as a guess, nor does the end of a game.
      // The attempts before it will be counted in the number of guesses.
      let numGuesses: Int
      if lastOutcome == .skipped || lastOutcome == .endGame {
        numGuesses = actionsPerClue.count - 1
      } else {
        numGuesses = actionsPerClue.count
      }
      
      return .init(numGuesses: numGuesses, outcome: lastOutcome, totalTimeElapsed: totalTimeElapsed, actualClue: lastAction.actualClue)
    }
    
    return result2
  }
  
  private var correctClueAttempts: [ClueAttempt] {
    attemptsPerClue.filter { $0.outcome == .correct }
  }
  
  private var skippedClueAttempts: [ClueAttempt] {
    attemptsPerClue.filter { $0.outcome == .skipped || $0.outcome == .endGame }
  }
  
  private(set) var highScore: Int {
    get { UserDefaults.standard.integer(forKey: "gameStats.highScore") }
    set {
      UserDefaults.standard.set(newValue, forKey: "gameStats.highScore")
    }
  }
  
  var isPersonalBest: Bool { highScore > personalBest }
  
  mutating func logAction(timeRemaining: TimeInterval, outcome: GuessOutcome, actualClue: String = "") {
    guessActions.append(.init(timeRemaining: timeRemaining, outcome: outcome, actualClue: actualClue))
  }
}

struct ClueAttempt {
  let numGuesses: Int
  let outcome: GuessOutcome
  let totalTimeElapsed: TimeInterval
  let actualClue: String
}

enum GuessOutcome: Equatable {
  case correct
  case incorrect(guess: String)
  case skipped
  case endGame
}

struct GuessAction {
  let timeRemaining: TimeInterval
  let outcome: GuessOutcome
  let actualClue: String
}
