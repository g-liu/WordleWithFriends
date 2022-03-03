//
//  WordGuess.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import Foundation

struct WordGuess {
  private var guess: [LetterGuess]
  
  init(guess: String = "") {
    self.guess = []
    updateGuess(guess)
  }
  
  var word: String {
    guess.reduce("") {
      "\($0)\($1.letter)"
    }
  }
  
  mutating func forceState(_ state: LetterState) {
    (0..<guess.count).forEach { index in
      guess[index].state = state
    }
  }
  
  mutating func updateGuess(_ newGuess: String) {
    guess = []
    for char in newGuess.uppercased() {
      guess.append(LetterGuess(char))
    }
  }
  
  func guess(at index: Int) -> LetterGuess? {
    guard index >= 0 && index < guess.count else { return nil }
    return guess[index]
  }
  
  /// Checks a player's guess
  /// - Parameter clue: the word to check against
  /// - Returns: true if the user guessed correctly; false otherwise
  mutating func checkGuess(against clue: String) -> Bool {
    var clue = clue
    var didGuessCorrectly = true
    
    // pass 1: find exact matches and incorrect guesses
    guess.enumerated().forEach { index, letterGuess in
      if letterGuess.letter == clue[index] {
        clue.replaceAt(index, with: "#")
        guess[index].state = .correct
      } else if !clue.contains(letterGuess.letter) {
        guess[index].state = .incorrect
        didGuessCorrectly = false
      }
    }
    
    // pass 2: the rest are misplaced or incorrect
    (0..<guess.count).forEach { index in
      if guess[index].state == .unchecked {
        if let indexInClue = clue.firstIndex(of: guess[index].letter) {
          clue.replaceAt(indexInClue, with: "#")
          guess[index].state = .misplaced
          didGuessCorrectly = false
        } else {
          guess[index].state = .incorrect
          didGuessCorrectly = false
        }
      }
    }
    
    return didGuessCorrectly
  }
  
  func asString() -> String {
    guess.reduce("") { $0 + String($1.state.rawValue) }
  }
}

extension WordGuess: Equatable { }

extension WordGuess: Sequence {
  func makeIterator() -> IndexingIterator<Array<LetterGuess>> {
    guess.makeIterator()
  }
}
