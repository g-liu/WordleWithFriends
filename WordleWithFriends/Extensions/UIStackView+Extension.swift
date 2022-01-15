//
//  UIStackView+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

extension UIStackView {
  
  func removeAllArrangedSubviews() {
    
    let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
      self.removeArrangedSubview(subview)
      return allSubviews + [subview]
    }
    
    // Deactivate all constraints
    NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    
    // Remove the views from self
    removedSubviews.forEach({ $0.removeFromSuperview() })
  }
}
