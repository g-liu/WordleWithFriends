//
//  LetterTileView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

enum LetterState {
  case unchecked
  case correct
  case misplaced
  case incorrect
}

final class LetterTileTableViewCell: UITableViewCell {
  static let identifier = "LetterTileTableViewCell"
  
  private lazy var letterLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = .monospacedSystemFont(ofSize: 24.0, weight: .bold)
    
    return label
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
    layer.borderColor = UIColor.darkText.cgColor
    layer.borderWidth = 1.0
    
    contentView.addSubview(letterLabel)
    letterLabel.pin(to: contentView)
    
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(equalToConstant: 75),
      contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
    ])
  }
  
  func configure(letter: String, state: LetterState) {
    letterLabel.text = letter
    switch state {
      case .correct:
        contentView.backgroundColor = .systemGreen
      case .misplaced:
        contentView.backgroundColor = .systemYellow
      case .incorrect:
        contentView.backgroundColor = .systemGray
      case .unchecked:
        contentView.backgroundColor = .systemBackground
    }
  }
}
