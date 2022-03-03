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
  private var keyReferences: [WeakRef<WordleKeyboardKey>] = []
  
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
        let keyView = WordleKeyboardKey(keyType: .submit)
        keyView.delegate = self
        stackView.addArrangedSubview(keyView)
        stackView.setCustomSpacing(4.0, after: keyView)
      }
      
      row.enumerated().forEach { index, char in
        let keyView = WordleKeyboardKey(keyType: .char(Character(char)))
        keyView.delegate = self
        stackView.addArrangedSubview(keyView)
        
        if index == row.count - 1 {
          stackView.setCustomSpacing(4.0, after: keyView)
        }
        
        keyReferences.append(WeakRef(value: keyView))
      }
      
      if isLastRow {
        // last row must add Backspace key
        let keyView = WordleKeyboardKey(keyType: .del)
        keyView.delegate = self
        stackView.addArrangedSubview(keyView)
      }
      
      mainStackView.addArrangedSubview(stackView)
    }
    
    keyReferences.sort { keyRef1, keyRef2 in
      guard let key1 = keyRef1.value, let key2 = keyRef2.value,
            case KeyType.char(let char1) = key1.keyType,
            case KeyType.char(let char2) = key2.keyType else { return false }
      
      return char1 < char2
    }
    
    addSubview(mainStackView)
    mainStackView.pin(to: safeAreaLayoutGuide, margins: UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8))
  }
  
  func updateState(with wordGuess: WordGuess) {
    // TODO: A different algorithm???
    wordGuess.forEach { letterGuess in
      guard let guessAsciiValue = letterGuess.letter.asciiValue else { return }
//      print(letterGuess.letter.asciiValue) // index based on THIS!!!!
      let indexInRefArray = Int(guessAsciiValue - (Character("A").asciiValue ?? 65))
//      for i in 0..<keyReferences.count {
//        if let keyType = keyReferences[i].value?.keyType,
//           case KeyType.char(let char) = keyType,
//           char == letterGuess.letter {
          keyReferences[indexInRefArray].value?.guessState = letterGuess.state
//        }
//      }
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
