//
//  WordGuessRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessRow: UITableViewCell {
  static let identifier = "WordGuessRow"
  
  private lazy var calculatedHeight: CGFloat = {
    let gridSize = LayoutUtility.gridSize(numberOfColumns: GameSettings.clueLength.readIntValue(),
                                          screenWidthPercentage: 85,
                                          maxSize: 50)
    
    return round(gridSize)
  }()
  
  private lazy var letterStack: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
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
      letterStack.addArrangedSubview(tile)
    }
    
    contentView.addSubview(letterStack)
    
    NSLayoutConstraint.activate([
      letterStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      letterStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
      letterStack.heightAnchor.constraint(equalToConstant: calculatedHeight),
      letterStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      letterStack.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor),
    ])
  }
  
  func configure(with wordGuess: WordGuess = .init()) {
    letterStack.removeAllArrangedSubviews()
    (0...(GameSettings.clueLength.readIntValue()-1)).forEach { index in
      let tile = LetterTileView(letterGuess: wordGuess.guess(at: index))
      letterStack.addArrangedSubview(tile)
    }
  }
}
