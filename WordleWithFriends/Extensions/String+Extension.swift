//
//  String+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

extension String {
  private static let checker = UITextChecker()
  
  func isLettersOnly() -> Bool {
    if isEmpty { return true }
    return self.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil && self != ""
  }
  
  func isARealWord() -> Bool {
    let range = NSRange(location: 0, length: capitalized.utf16.count)
    let misspelledRange = String.checker.rangeOfMisspelledWord(in: capitalized, range: range, startingAt: 0, wrap: false, language: Locale.current.identifier)
    
    return misspelledRange.location == NSNotFound
  }
  
  func index(_ i: Int) -> String.Index {
    index(startIndex, offsetBy: i)
  }

  func range(_ start: Int, _ end: Int) -> ClosedRange<String.Index> {
    index(start)...index(end)
  }
}

extension StringProtocol {
  subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }
}
