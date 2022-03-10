//
//  CharacterSet+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/9/22.
//

import Foundation

extension CharacterSet {
  mutating func insert(_ char: Character) {
    if let unicodeScalar = char.asUnicodeScalar {
      insert(unicodeScalar)
    }
  }
}
