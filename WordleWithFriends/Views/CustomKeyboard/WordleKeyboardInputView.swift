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
  func didTapSubmit()
  func didTapDelete()
}

final class WordleKeyboardInputView: UIView {
  private struct Layout {
    static let interKeySpacing = 4.0
    static let rowSpacing = 8.0
    static let specialKeySpacing = 8.0
    static let topPadding = 8.0
  }
  private var keyReferences: [WeakRef<WordleKeyboardKey>] = []
  
  // TODO make customizable?
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
    stackView.spacing = Layout.rowSpacing
    
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
    backgroundColor = .tertiarySystemFill
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
    ])
    
    type(of: self).keyboardLayout.enumerated().forEach { index, row in
      let stackView = UIStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.spacing = Layout.interKeySpacing
      stackView.axis = .horizontal
      stackView.alignment = .fill
      
      let isLastRow = index == type(of: self).keyboardLayout.count - 1
      
      if isLastRow {
        // last row must add Enter key (Submit guess)
        let keyView = WordleKeyboardKey(keyType: .submit)
        keyView.delegate = self
        stackView.addArrangedSubview(keyView)
        stackView.setCustomSpacing(Layout.specialKeySpacing, after: keyView)
      }
      
      row.enumerated().forEach { index, char in
        let keyView = WordleKeyboardKey(keyType: .char(Character(char)))
        keyView.delegate = self
        stackView.addArrangedSubview(keyView)
        
        keyReferences.append(WeakRef(value: keyView))
        
        if isLastRow && index == row.count - 1 {
          stackView.setCustomSpacing(Layout.specialKeySpacing, after: keyView)
          // last row must add Backspace key
          let keyView = WordleKeyboardKey(keyType: .del)
          keyView.delegate = self
          stackView.addArrangedSubview(keyView)
        }
      }
      
      mainStackView.addArrangedSubview(stackView)
    }
    
    // Sort key references A->Z for better lookup later
    keyReferences.sort { keyRef1, keyRef2 in
      guard let key1 = keyRef1.value, let key2 = keyRef2.value,
            case KeyType.char(let char1) = key1.keyType,
            case KeyType.char(let char2) = key2.keyType else { return false }
      
      return char1 < char2
    }
    
    addSubview(mainStackView)
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Layout.topPadding),
      mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
    ])
  }
  
  func updateState(with wordGuess: WordGuess) {
    wordGuess.forEach { letterGuess in
      guard let guessAsciiValue = letterGuess.letter.asciiValue else { return }
      let indexInRefArray = Int(guessAsciiValue - (Character("A").asciiValue ?? 65))
      keyReferences[indexInRefArray].value?.updateGuessState(letterGuess.state)
    }
  }
}

extension WordleKeyboardInputView: KeyTapDelegate {
  func didTapKey(_ char: Character) {
    delegate?.didTapKey(char)
  }
  
  func didTapDelete() {
    delegate?.didTapDelete()
  }
  
  func didTapSubmit() {
    delegate?.didTapSubmit()
  }
}
