//
//  GameGuessesModel.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

struct GameGuessesModel {
  var actualWord: String = ""
  var guessLimit: Int = 6
  private var letterGuesses: [WordGuess] = [WordGuess()]
  
  func guess(at index: Int) -> WordGuess? {
    guard index < letterGuesses.count else { return nil }
    return letterGuesses[index]
  }
  
  mutating func updateGuess(_ newGuess: String) {
    letterGuesses[letterGuesses.count - 1].updateGuess(newGuess)
  }
  
  /// Submit a guess
  /// - Returns: if the user guessed the word correctly
  mutating func submitGuess() -> GameState {
    let didGuessCorrectly = letterGuesses[letterGuesses.count - 1].checkGuess(against: actualWord)
    
    letterGuesses.append(WordGuess())
    if didGuessCorrectly {
      return .win
    } else if letterGuesses.count > guessLimit {
      return .lose
    } else {
      return .keepGuessing
    }
  }
  
  func copyResult() {
    let header = "Wordle With Friends - \(letterGuesses.count)/\(guessLimit)"
    UIPasteboard.general.string = letterGuesses.reduce(header) { copyString, guess in
      return copyString + "\n\(guess.asString())"
    }
  }
  
  mutating func markInvalidGuess() {
    letterGuesses[letterGuesses.count - 1].forceState(.invalid)
  }
  
  mutating func clearInvalidGuess() {
    letterGuesses[letterGuesses.count - 1].forceState(.unchecked)
  }
  
  var numberOfGuesses: Int { letterGuesses.count }
}

enum LetterState: Character {
  case unchecked = "⬛️"
  case correct = "🟩"
  case misplaced = "🟨"
  case incorrect = "⬜️"
  case invalid = "🟥"
}

enum GameState {
  case win
  case lose
  case keepGuessing
}
