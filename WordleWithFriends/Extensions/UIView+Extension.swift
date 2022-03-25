//
//  UIView+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

extension UIView {
  var autolayoutEnabled: Self {
    translatesAutoresizingMaskIntoConstraints = false
    return self
  }
  
  func pin(to otherView: UIView, margins: UIEdgeInsets = .zero) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: otherView.topAnchor, constant: margins.top),
      bottomAnchor.constraint(equalTo: otherView.bottomAnchor, constant: -margins.bottom),
      leadingAnchor.constraint(equalTo: otherView.leadingAnchor, constant: margins.left),
      trailingAnchor.constraint(equalTo: otherView.trailingAnchor, constant: -margins.right),
    ])
  }
  
  func pin(to layoutGuide: UILayoutGuide, margins: UIEdgeInsets = .zero) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: margins.top),
      bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -margins.bottom),
      leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: margins.left),
      trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -margins.right),
    ])
  }
  
  func removeAllGestureRecognizers() {
    gestureRecognizers?.forEach { removeGestureRecognizer($0) }
  }
  
  func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axes: NSLayoutConstraint.Axis...) {
    axes.forEach { axis in
      setContentCompressionResistancePriority(priority, for: axis)
    }
  }
  
  func setContentHuggingPriority(_ priority: UILayoutPriority, for axes: NSLayoutConstraint.Axis...) {
    axes.forEach { axis in
      setContentHuggingPriority(priority, for: axis)
    }
  }
}
