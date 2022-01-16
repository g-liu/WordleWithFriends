//
//  WordGuessRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessRow: UITableViewCell {
  static let identifier = "WordGuessRow"
  
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
    (0...(GameSettings.clueLength.readIntValue()-1)).forEach { _ in
      let tile = LetterTileView()
      tile.configure()
      letterStack.addArrangedSubview(tile)
    }
    
    contentView.addSubview(letterStack)
    
    NSLayoutConstraint.activate([
      letterStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      letterStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      letterStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
    ])
  }
  
  func configure(with wordGuess: WordGuess = .init()) {
    letterStack.removeAllArrangedSubviews()
    (0...(GameSettings.clueLength.readIntValue()-1)).forEach { index in
      let tile = LetterTileView()
      if let guess = wordGuess.guess(at: index) {
        tile.configure(guess)
      } else {
        tile.configure()
      }
      letterStack.addArrangedSubview(tile)
    }
  }
}
