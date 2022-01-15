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
    var indicesToCheck = Set(0...4)
    
    var actualWord = actualWord
    
    // first pass check for exact matches
    indicesToCheck.forEach { index in
      let letterGuess = guess[index]
      if letterGuess.letter == actualWord[index] {
        // don't check that index anymore
        _ = indicesToCheck.remove(index)
        // X out the character in `actualWord` so that we don't double over it
        actualWord.replaceSubrange(actualWord.range(index, index), with: "#")
        // Mark the guess as correct
        guess[index].state = .correct
      }
    }
    
    // 2nd pass: check for misplaced matches
    indicesToCheck.forEach { index in
      let letterGuess = guess[index]
      if let indexInActualWord = actualWord.firstIndex(of: letterGuess.letter) {
        // X out the character in `actual word` so that we don't double over it
        actualWord.replaceSubrange(actualWord.range(indexInActualWord, indexInActualWord), with: "#")
        // mark the guess as misspelled
        guess[index].state = .misplaced
      }
    }
    
    // 3rd pass: the rest, are incorrect guesses
    (0...4).forEach { index in
      if guess[index].state == .unchecked {
        guess[index].state = .incorrect
      }
    }
    //    guess = guess.enumerated().map { index, guess in
    //      if guess.letter == actualWord[index] {
    //        return LetterGuess(guess.letter, state: .correct)
    //      } else if actualWord.contains(guess.letter) {
    //        return LetterGuess(guess.letter, state: .misplaced)
    //      } else {
    //        return LetterGuess(guess.letter, state: .incorrect)
    //      }
    //    }
  }
}
