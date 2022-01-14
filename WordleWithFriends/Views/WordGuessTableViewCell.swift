//
//  WordGuessTableViewCell.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessTableViewCell: UITableViewCell {
  static let identifier = "LetterTileTableViewCell"
  
  private lazy var letterStack: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = 12.0
    
    return stackView
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
    (0...4).forEach { _ in
      let tile = LetterTileView()
      tile.configure(letter: " ", state: .unchecked)
      letterStack.addArrangedSubview(tile)
    }
    
    contentView.addSubview(letterStack)
    
    NSLayoutConstraint.activate([
      letterStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      letterStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      letterStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
    ])
  }
}
