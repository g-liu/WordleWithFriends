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
    let misspelledRange = String.checker.rangeOfMisspelledWord(in: capitalized, range: range, startingAt: 0, wrap: false, language: "en") // TODO: Locale???
    
    return misspelledRange.location == NSNotFound
  }

}
