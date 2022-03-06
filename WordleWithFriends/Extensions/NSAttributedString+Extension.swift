//
//  NSAttributedString+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/5/22.
//

import Foundation

extension NSAttributedString {
  var asMutable: NSMutableAttributedString { .init(attributedString: self) }
  
  func append(_ string: String) -> NSAttributedString {
    let mutableString = self.asMutable
    mutableString.append(NSAttributedString(string: string))
    return mutableString
  }
}
