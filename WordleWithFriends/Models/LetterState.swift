//
//  LetterState.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/2/22.
//

import UIKit

enum LetterState: Character {
  case unchecked = "⬛️"
  case correct = "🟩"
  case misplaced = "🟨"
  case incorrect = "⬜️"
  case invalid = "🟥"
  
  var associatedColor: UIColor {
    switch self {
      case .unchecked:
        return .systemBackground
      case .correct:
        return .systemGreen
      case .misplaced:
        return .systemYellow
      case .incorrect:
        return .systemGray
      case .invalid:
        return .clear
    }
  }
  
  var priority: Int {
    switch self {
      case .unchecked:
        return -1
      case .correct:
        return 10
      case .misplaced:
        return 5
      case .incorrect:
        return 0
      case .invalid:
        return -100
    }
  }
}

extension LetterState: Comparable {
  static func < (lhs: LetterState, rhs: LetterState) -> Bool {
    lhs.priority < rhs.priority
  }
}
