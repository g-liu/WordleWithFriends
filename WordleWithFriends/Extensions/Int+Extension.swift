//
//  Int+Extension.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import Foundation

extension Int {
  static var formatter: NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.numberStyle = .spellOut
    return fmt
  }()
  
  var spelledOut: String? {
    type(of: self).formatter.string(from: self as NSNumber)
  }
}
