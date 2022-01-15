//
//  GameGuessesModel.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

struct GameGuessesModel {
  var actualWord: String = ""
  private var guesses: [WordGuess] = [WordGuess()]
  
  func guess(at index: Int) -> WordGuess? {
    guard index < guesses.count else { return nil }
    return guesses[index]
  }
  
  mutating func updateGuess(_ newGuess: String) {
    guesses[guesses.count - 1].updateGuess(newGuess)
  }
  
  mutating func submitGuess() {
    guesses[guesses.count - 1].checkGuess(against: actualWord)
    
    guesses.append(WordGuess())
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
