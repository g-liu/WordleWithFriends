//
//  ToastView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/4/22.
//

import UIKit

final class ToastView: UIView {
  init(text: String) {
    super.init(frame: .zero)
    setupView(text)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView(_ text: String = "") {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .systemGray2
    layer.cornerRadius = 3.0
    layer.masksToBounds = false
    layer.shadowOffset = .init(width: 1, height: 1)
    layer.shadowColor = UIColor.systemGray5.cgColor
    layer.shadowRadius = 2
    layer.shadowOpacity = 0.5
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    isOpaque = true
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.text = text
    
    addSubview(label)
    label.pin(to: self, margins: UIEdgeInsets(top: 12, left: 18, bottom: 12, right: 18))
  }
}
