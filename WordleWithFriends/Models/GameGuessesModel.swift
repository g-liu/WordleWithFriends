//
//  GameGuessesModel.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

struct GameGuessesModel {
  let clue: String
  let gamemode: GameMode
  private(set) var isGameOver: Bool = false
  
  private var letterGuesses: [WordGuess] = [WordGuess()]
  
  /// The number of completed guesses
  var numberOfGuesses: Int { letterGuesses.count - 1 }
  
  init(clue: String, gamemode: GameMode) {
    self.clue = clue
    self.gamemode = gamemode
  }
  
  func guess(at index: Int) -> WordGuess? {
    guard index < letterGuesses.count else { return nil }
    return letterGuesses[index]
  }
  
  var mostRecentGuess: WordGuess? {
    guard numberOfGuesses >= 1 else { return nil }
    return letterGuesses[numberOfGuesses - 1]
  }
  
  mutating func updateGuess(_ newGuess: String) {
    letterGuesses[letterGuesses.count - 1].updateGuess(newGuess)
  }
  
  mutating func forceGameOver() {
    isGameOver = true
  }
  
  /// Submit a guess
  /// - Returns: if the user guessed the word correctly
  @discardableResult
  mutating func submitGuess() -> GameState {
    let didGuessCorrectly = letterGuesses[letterGuesses.count - 1].checkGuess(against: clue)
    
    letterGuesses.append(WordGuess())
    if didGuessCorrectly {
      isGameOver = true
      return .win
    } else if gamemode != .infinite && letterGuesses.count > GameSettings.maxGuesses.readIntValue() {
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

enum GameState {
  case win
  case lose
  case keepGuessing
}

enum GameMode {
  case human
  case computer
  case infinite
}
