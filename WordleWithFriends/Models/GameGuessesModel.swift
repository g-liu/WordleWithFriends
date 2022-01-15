//
//  GameGuessesModel.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

struct GameGuessesModel {
  private var guesses: [WordGuessModel] = [WordGuessModel()]
  
  func guess(at index: Int) -> WordGuessModel? {
    guard index < guesses.count else { return nil }
    return guesses[index]
  }
  
  mutating func updateGuess(_ newGuess: String, at index: Int) {
    guard index < guesses.count else { return }
    guesses[index].updateGuess(newGuess)
  }
  
  func submitGuess() {
    // TODO!!!!
  }
  
  var numberOfGuesses: Int { guesses.count }
}



// todo move
struct WordGuessModel {
  private var guess: [LetterGuess]
  
  init() {
    guess = []
  }
  
  mutating func updateGuess(_ newGuess: String) {
    guess = []
    for char in newGuess {
      guess.append(LetterGuess(char))
    }
  }
  
  func guess(at index: Int) -> LetterGuess? {
    guard index < guess.count else { return nil }
    return guess[index]
  }
}

// todo move
struct LetterGuess {
  static let `default` = LetterGuess(" ", state: .unchecked)
  
  let letter: Character
  let state: LetterState
  
  init(_ letter: String.Element, state: LetterState = .unchecked) {
    self.letter = letter
    self.state = state
  }
}
