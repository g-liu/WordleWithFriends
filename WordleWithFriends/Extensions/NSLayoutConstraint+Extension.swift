//
//  NSLayoutConstraint+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

extension NSLayoutConstraint {
  func with(priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    
    return self
  }
  
  func with(priority: Int) -> NSLayoutConstraint {
    return with(priority: UILayoutPriority(priority.asFloat))
  }
}
