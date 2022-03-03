//
//  WordleKeyboardKey.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/2/22.
//

import Foundation
import UIKit

enum KeyType {
  case char(Character)
  case submit
  case del
}

final class WordleKeyboardKey: UIButton {
  var keyType: KeyType {
    didSet {
      switch keyType {
        case .char(let character):
          characterLabel.text = "\(character)"
        case .submit:
          characterLabel.text = "⏎"
        case .del:
          characterLabel.text = "⌫"
      }
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
  
  init(keyType: KeyType) {
    self.keyType = .del
    defer {
      self.keyType = keyType
    }
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  //
//
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    setupView()
//  }
//
//  required init?(coder: NSCoder) {
//    super.init(coder: coder)
//    setupView()
//  }
  
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
    UIDevice.current.playInputClick()
    switch keyType {
      case .char(let character):
        delegate?.didTapKey(character)
      case .submit:
        delegate?.didTapSubmit()
      case .del:
        delegate?.didTapDelete()
    }
  }
}
