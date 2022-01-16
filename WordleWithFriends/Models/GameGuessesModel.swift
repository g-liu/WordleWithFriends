//
//  GameGuessesModel.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

struct GameGuessesModel {
  var actualWord: String = ""
  var isGameOver: Bool = false
  
  private var letterGuesses: [WordGuess] = [WordGuess()]
  
  var numberOfGuesses: Int { letterGuesses.count - 1 }
  
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
      isGameOver = true
      return .win
    } else if letterGuesses.count > GameSettings.maxGuesses.readIntValue() {
      isGameOver = true
      return .lose
    } else {
      isGameOver = false
      return .keepGuessing
    }
  }
  
  func copyResult() {
    let header = "Wordle With Friends - \(letterGuesses.count-1)/\(GameSettings.maxGuesses.readIntValue())\n"
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
