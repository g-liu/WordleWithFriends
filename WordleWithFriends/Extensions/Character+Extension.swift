//
//  Character+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import Foundation

extension Character {
  static let space: Character = " "
  
  var asUnicodeScalar: Unicode.Scalar? {
    if let asciiValue = asciiValue {
      return .init(asciiValue)
    }
    
    return nil
  }
}
