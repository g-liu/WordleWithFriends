//
//  WhatTheFuckGuessRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/21/22.
//

import UIKit

final class WhatTheFuckGuessRow: UITableViewCell {
  static let identifier = "WhatTheFuckGuessRow"
  
  private lazy var calculatedWidth: CGFloat = round(LayoutUtility.gridSize(numberOfColumns: GameSettings.clueLength.readIntValue(),
                                                                screenWidthPercentage: 85,
                                                                maxSize: 50))
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.alignment = .fill
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
    contentView.backgroundColor = .systemBrown
    contentView.addSubview(stackView)
    (0..<GameSettings.clueLength.readIntValue()).forEach { _ in stackView.addArrangedSubview(LetterTileView()) }
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      stackView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
      stackView.heightAnchor.constraint(equalToConstant: calculatedWidth),
    ])
//    stackView.pin(to: contentView)
  }
}
