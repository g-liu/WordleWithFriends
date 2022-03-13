//
//  GameStatistics.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/12/22.
//

import Foundation

struct GameStatistics {
  let averageTimePerCompletedClue: Double
  let averageTimePerSkippedClue: Double
  var averageTimePerClue: Double {
    guard totalClues > 0 else { return 0 }
    return (averageTimePerCompletedClue * numCompletedClues + averageTimePerSkippedClue * numSkippedClues) / totalClues
  }
  
  let averageGuessesPerCompletedClue: Double
  let averageGuessesPerSkippedClue: Double
  var averageGuessesPerClue: Double {
    guard totalClues > 0 else { return 0 }
    return (averageGuessesPerCompletedClue * numCompletedClues + averageGuessesPerSkippedClue * numSkippedClues) / totalClues
  }
  
  let lowestGuessCountForCompletedClue: Int
  let highestGuessCountForCompletedClue: Int
  
  let fastestGuessForCompletedClue: TimeInterval
  let slowestGuessForCompletedClue: TimeInterval
  
  let numCompletedClues: Int
  let numSkippedClues: Int
  var totalClues: Int { numCompletedClues + numSkippedClues }
  
  var percentCompleted: Double {
    guard totalClues > 0 else { return 0 }
    return round((numCompletedClues.asDouble / totalClues) * 100)
  }
  
  let totalGuesses: Int
  
  let personalBest: Int
  
  var isNewPersonalBest: Bool { numCompletedClues > personalBest }
}

