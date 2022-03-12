//
//  NSMutableAttributedString+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/11/22.
//

import Foundation

extension NSMutableAttributedString {
  func appending(_ attributedString: NSAttributedString) -> NSMutableAttributedString {
    append(attributedString)
    return self
  }
  
  func appending(_ string: String) -> NSMutableAttributedString {
    appending(string.asAttributedString)
  }
}
