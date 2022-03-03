//
//  WordleKeyboardInputView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/2/22.
//

import Foundation
import UIKit

protocol KeyTapDelegate {
  func didTapKey(_ char: Character)
}

final class WordleKeyboardInputView: UIView {
  // TODO make customizable
  private static let keyboardLayout = [[
    "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
  ], [
    "A", "S", "D", "F", "G", "H", "J", "K", "L",
  ], [
    "Z", "X", "C", "V", "B", "N", "M",
  ]]
  
  var delegate: KeyTapDelegate?
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.spacing = 4.0
    
    return stackView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupKeyboard()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupKeyboard()
  }
  
  private func setupKeyboard() {
    backgroundColor = .secondarySystemBackground
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
    ])
    
    type(of: self).keyboardLayout.enumerated().forEach { index, row in
      let stackView = UIStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.spacing = 2.0
      stackView.axis = .horizontal
      stackView.alignment = .fill
      
      let isLastRow = index == type(of: self).keyboardLayout.count - 1
      
      if isLastRow {
        // last row must add Enter character
        let keyView = WordleKeyboardKey()
        keyView.char = "⏎"
        stackView.addArrangedSubview(keyView)
        stackView.setCustomSpacing(4.0, after: keyView)
      }
      
      row.enumerated().forEach { index, key in
        let keyView = WordleKeyboardKey()
        keyView.char = Character(key)
        keyView.delegate = self
        stackView.addArrangedSubview(keyView)
        
        if index == row.count - 1 {
          stackView.setCustomSpacing(4.0, after: keyView)
        }
      }
      
      if isLastRow {
        // last row must add Backspace key
        let keyView = WordleKeyboardKey()
        keyView.char = "⌫"
        stackView.addArrangedSubview(keyView)
      }
      
      mainStackView.addArrangedSubview(stackView)
      
    }
    
    addSubview(mainStackView)
    mainStackView.pin(to: safeAreaLayoutGuide, margins: UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8))
  }
}

extension WordleKeyboardInputView: KeyTapDelegate {
  func didTapKey(_ char: Character) {
    delegate?.didTapKey(char)
  }
}
