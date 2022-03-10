//
//  Set+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/9/22.
//

import Foundation

extension Set where Element == Character {
  var asCommaSeparatedList: String {
    map { String($0) }.joined(separator: ", ")
  }
}
