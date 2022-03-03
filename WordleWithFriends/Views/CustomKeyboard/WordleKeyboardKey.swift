//
//  WordleKeyboardKey.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/2/22.
//

import Foundation
import UIKit

final class WordleKeyboardKey: UIButton {
  var char: Character = " " {
    didSet {
      characterLabel.text = "\(char)"
    }
  }
  
  var guessState: LetterState = .unchecked {
    didSet {
      backgroundColor = guessState.associatedColor // TODO verify
    }
  }
  
  var delegate: KeyTapDelegate?
  
  private lazy var characterLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .systemFill // TODO what's the right color??
    label.textAlignment = .center
    label.font = label.font.withSize(24.0)
    
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    
    layer.cornerRadius = 3.0
    layer.masksToBounds = false
    backgroundColor = guessState.associatedColor
    
    addSubview(characterLabel)
    characterLabel.pin(to: self, margins: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: 32.0), // todo dynamically calculate based on fattest letter
    ])
    
    addTarget(self, action: #selector(didTapKey), for: .touchUpInside)
  }
  
  @objc private func didTapKey() {
    delegate?.didTapKey(char)
  }
}
