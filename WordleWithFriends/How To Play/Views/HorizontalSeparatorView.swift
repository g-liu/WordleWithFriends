//
//  HorizontalSeparatorView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/5/22.
//

import UIKit

final class HorizontalSeparatorView: UIView {
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
    
    heightAnchor.constraint(equalToConstant: 2.0).with(priority: .required).isActive = true
    setContentCompressionResistancePriority(.required, for: .vertical)
    
    if let superview = superview {
      widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
    }
  }
}
