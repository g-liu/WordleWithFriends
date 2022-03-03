//
//  LetterGuess.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import Foundation

struct LetterGuess {
  static let `default` = LetterGuess(.space, state: .unchecked)
  
  var letter: Character
  var state: LetterState
  
  init(_ letter: String.Element, state: LetterState = .unchecked) {
    self.letter = letter
    self.state = state
  }
}

extension LetterGuess: Equatable { }
