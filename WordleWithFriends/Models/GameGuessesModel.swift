//
//  GameGuessesModel.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

struct GameGuessesModel {
  var actualWord: String = ""
  var guessLimit: Int = 6
  private var guesses: [WordGuess] = [WordGuess()]
  
  func guess(at index: Int) -> WordGuess? {
    guard index < guesses.count else { return nil }
    return guesses[index]
  }
  
  mutating func updateGuess(_ newGuess: String) {
    guesses[guesses.count - 1].updateGuess(newGuess)
  }
  
  /// Submit a guess
  /// - Returns: if the user guessed the word correctly
  mutating func submitGuess() -> GameState {
    let didGuessCorrectly = guesses[guesses.count - 1].checkGuess(against: actualWord)
    
    guesses.append(WordGuess())
    if didGuessCorrectly {
      return .win
    } else if guesses.count > guessLimit {
      return .lose
    } else {
      return .keepGuessing
    }
  }
  
  mutating func markInvalidGuess() {
    guesses[guesses.count - 1].forceState(.invalid)
  }
  
  mutating func clearInvalidGuess() {
    guesses[guesses.count - 1].forceState(.unchecked)
  }
  
  var numberOfGuesses: Int { guesses.count }
}

enum LetterState {
  case unchecked
  case correct
  case misplaced
  case incorrect
  case invalid
}

enum GameState {
  case win
  case lose
  case keepGuessing
}
