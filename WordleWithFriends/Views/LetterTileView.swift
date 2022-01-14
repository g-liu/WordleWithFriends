//
//  LetterTileView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

// TODO MOVE THIS
enum LetterState {
  case unchecked
  case correct
  case misplaced
  case incorrect
}


final class LetterTileView: UIView {
  private lazy var letterLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    
    label.font = .monospacedSystemFont(ofSize: 24.0, weight: .bold)
    
    return label
  }()
  
  init() {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    layer.borderColor = UIColor.darkText.cgColor
    layer.borderWidth = 1.0
    
    addSubview(letterLabel)
    letterLabel.pin(to: self)
    
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 50),
      widthAnchor.constraint(equalTo: heightAnchor),
    ])
  }
  
  func configure(letter: String, state: LetterState) {
    letterLabel.text = letter
    switch state {
      case .correct:
        backgroundColor = .systemGreen
      case .misplaced:
        backgroundColor = .systemYellow
      case .incorrect:
        backgroundColor = .systemGray
      case .unchecked:
        backgroundColor = .systemBackground
    }
  }
}
