//
//  String+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

extension String {
  var asInt: Int? { .init(self) }
  var asFloat: Float? { .init(self) }
  var asDouble: Double? { .init(self) }
  var asTimeInterval: TimeInterval? { .init(self) }
  var asBool: Bool? { .init(self) }
  
  private static let checker = UITextChecker()
  
  var isLettersOnly: Bool {
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
  
  func range(_ start: Index, _ end: Index) -> ClosedRange<String.Index> {
    index(start, offsetBy: 0)...index(end, offsetBy: 0)
  }
  
  mutating func replaceAt(_ i: Int, with character: Character) {
    replaceAt(index(i), with: character)
  }
  
  mutating func replaceAt(_ index: Index, with character: Character) {
    replaceSubrange(range(index, index), with: String(character))
  }
}

extension String {
  subscript(value: CountableClosedRange<Int>) -> Substring {
    self[index(value.lowerBound)...index(value.upperBound)]
  }

  subscript(value: CountableRange<Int>) -> Substring {
    self[index(value.lowerBound)..<index(value.upperBound)]
  }

  subscript(value: PartialRangeUpTo<Int>) -> Substring {
    self[..<index(value.upperBound)]
  }

  subscript(value: PartialRangeThrough<Int>) -> Substring {
    self[...index(value.upperBound)]
  }

  subscript(value: PartialRangeFrom<Int>) -> Substring {
    self[index(value.lowerBound)...]
  }
  
  subscript(value: NSRange) -> Substring {
    self[value.lowerBound..<value.upperBound]
  }
  
  subscript(value: Int) -> Character {
    self[index(value)]
  }
}

extension String {
  var asAttributedString: NSAttributedString { .init(string: self) }
  
  var bolded: NSMutableAttributedString {
    .init(string: self, attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)])
  }
  
  func appending(_ attributedString: NSAttributedString) -> NSMutableAttributedString {
    let mutableString = NSMutableAttributedString(string: self)
    mutableString.append(attributedString)
    
    return mutableString
  }
}

extension StringProtocol {
  subscript(offset: Int) -> Character {
    self[index(startIndex, offsetBy: offset)]
  }
}
extension Substring {
  var asString: String { .init(self) }
}
