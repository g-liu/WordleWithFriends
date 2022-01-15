//
//  WordGuess.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import Foundation

struct WordGuess {
  private var guess: [LetterGuess]
  
  init() {
    guess = []
  }
  
  mutating func forceState(_ state: LetterState) {
    (0..<guess.count).forEach { index in
      guess[index].state = state
    }
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
    var actualWord = actualWord
    
    // pass 1: find exact matches and incorrect guesses
    guess.enumerated().forEach { index, letterGuess in
      if letterGuess.letter == actualWord[index] {
        actualWord.replaceAt(index, with: "#")
        guess[index].state = .correct
      } else if !actualWord.contains(letterGuess.letter) {
        guess[index].state = .incorrect
      }
    }
    
    // pass 2: the rest are misplaced or incorrect
    (0..<guess.count).forEach { index in
      if guess[index].state == .unchecked {
        if let indexInActualWord = actualWord.firstIndex(of: guess[index].letter) {
          actualWord.replaceAt(indexInActualWord, with: "#")
          guess[index].state = .misplaced
        } else {
          guess[index].state = .incorrect
        }
      }
    }
  }
}
