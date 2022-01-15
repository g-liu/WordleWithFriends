//
//  GameGuessesModel.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

struct GameGuessesModel {
  var actualWord: String = ""
  private var guesses: [WordGuessModel] = [WordGuessModel()]
  
  func guess(at index: Int) -> WordGuessModel? {
    guard index < guesses.count else { return nil }
    return guesses[index]
  }
  
  mutating func updateGuess(_ newGuess: String) {
    guesses[guesses.count - 1].updateGuess(newGuess)
  }
  
  mutating func submitGuess() {
    guesses[guesses.count - 1].checkGuess(against: actualWord)
    
    guesses.append(WordGuessModel())
  }
  
  var numberOfGuesses: Int { guesses.count }
}


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
  
  mutating func checkGuess(against actualWord: String) {
    // TODO IMPORTANT!!! IS THE ALGO WRONG e.g. "ALLOW"-word vs "ABATE"-guess????
//    var checkedGuess = [LetterGuess]()
    guess = guess.enumerated().map { index, guess in
      if guess.letter == actualWord[index] {
        return LetterGuess(guess.letter, state: .correct)
      } else if actualWord.contains(guess.letter) {
        return LetterGuess(guess.letter, state: .misplaced)
      } else {
        return LetterGuess(guess.letter, state: .incorrect)
      }
    }
  }
}

struct LetterGuess {
  static let `default` = LetterGuess(" ", state: .unchecked)
  
  let letter: Character
  let state: LetterState
  
  init(_ letter: String.Element, state: LetterState = .unchecked) {
    self.letter = letter
    self.state = state
  }
}

enum LetterState {
  case unchecked
  case correct
  case misplaced
  case incorrect
}
