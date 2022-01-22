//
//  LetterTileView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit


final class LetterTileView: UIView {
  private lazy var letterLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    
    label.font = .monospacedSystemFont(ofSize: 28.0, weight: .bold)
    
    return label
  }()
  
  init(letterGuess: LetterGuess? = nil) {
    super.init(frame: .zero)
    configure(letterGuess)
    
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  

  private func configure(_ letterGuess: LetterGuess? = nil) {
    let letterGuess = letterGuess ?? .default
    translatesAutoresizingMaskIntoConstraints = false

    layer.borderColor = UIColor.separator.cgColor
    layer.borderWidth = 1.0
    
    addSubview(letterLabel)
    letterLabel.pin(to: self)
    
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalTo: heightAnchor),
    ])
  
    letterLabel.text = String(letterGuess.letter)
    layer.borderColor = UIColor.separator.cgColor
    layer.borderWidth = 1.0
    
    switch letterGuess.state {
      case .correct:
        backgroundColor = .systemGreen
      case .misplaced:
        backgroundColor = .systemYellow
      case .incorrect:
        backgroundColor = .systemGray
      case .unchecked:
        if letterGuess.letter != .space {
          layer.borderWidth = 3.0
        }
        backgroundColor = .systemBackground
      case .invalid:
        layer.borderColor = UIColor.systemRed.cgColor
        layer.borderWidth = 3.0
    }
  }
}
