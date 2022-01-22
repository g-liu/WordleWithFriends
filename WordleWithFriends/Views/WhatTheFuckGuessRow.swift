//
//  WhatTheFuckGuessRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/21/22.
//

import UIKit

final class WhatTheFuckGuessRow: UITableViewCell {
  static let identifier = "WhatTheFuckGuessRow"
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.alignment = .center
    stack.spacing = 8.0
    
    return stack
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupCell()
  }
  
  private func setupCell() {
//    contentView.backgroundColor = .systemBrown
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.heightAnchor.constraint(equalToConstant: 50),
    ])
    stackView.pin(to: contentView)
  }
}
