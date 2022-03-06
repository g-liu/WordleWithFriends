//
//  HorizontalSeparatorView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/5/22.
//

import UIKit

final class HorizontalSeparatorView: UIView {
  private weak var widthConstraint: NSLayoutConstraint?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    backgroundColor = .systemGray
    translatesAutoresizingMaskIntoConstraints = false
    
    heightAnchor.constraint(equalToConstant: 1.0).with(priority: .required).isActive = true
    setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if let superview = superview {
      if let widthConstraint = widthConstraint {
        widthConstraint.isActive = false
      }
      widthConstraint = widthAnchor.constraint(equalTo: superview.widthAnchor)
      widthConstraint?.isActive = true
    }
  }
}
