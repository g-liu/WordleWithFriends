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
    static let rowSpacing = 8.0
    static let topPadding = 8.0
  }
  private var keyReferences: [WeakRef<WordleKeyboardKey>] = []
  
  // TODO make customizable?
  private static let keyboardLayout: [[Character]] = [[
    "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
  ], [
    "A", "S", "D", "F", "G", "H", "J", "K", "L",
  ], [
    "Z", "X", "C", "V", "B", "N", "M",
  ]]
  
  var delegate: KeyTapDelegate? {
    didSet {
      setupKeyboard()
    }
  }
  
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
//    setupKeyboard()
    // TODO: Fuck you this doesn't work with custom inputView
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
//    setupKeyboard()
    // TODO: Fuck you this doesn't work with custom inputView
//    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
  }
  
  @objc private func keyboardWillShow(_ notification: Notification) {
    guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    let keyboardRectangle = keyboardFrame.cgRectValue
    let keyboardWidth = keyboardRectangle.width
    
    guard let maxKeysInARow = type(of: self).keyboardLayout.max(by: { $0.count < $1.count })?.count else { return }
    let totalSpace = KeyboardRow.Layout.interKeySpacing * Double(maxKeysInARow + 1)
    
    let keyWidth = CGFloat((keyboardWidth - totalSpace) / Double(maxKeysInARow))
    setupKeyboard(keyWidth: keyWidth)
  }
  
  static func getPortraitModeKeyWidth() -> CGFloat {
    let keyboardWidth = UIScreen.main.bounds.width
    let keyboardRowKeyWidths = keyboardLayout.enumerated().map { index, row -> CGFloat in
      let isLastRow = index == keyboardLayout.count - 1
      
      let totalSpace: Double; let keysInRow: Int
      if isLastRow {
        totalSpace = KeyboardRow.Layout.interKeySpacing * Double(row.count + 1) + 2 * KeyboardRow.Layout.specialKeySpacing
        keysInRow = row.count + 2
      } else {
        totalSpace = KeyboardRow.Layout.interKeySpacing * Double(row.count + 1)
        keysInRow = row.count
      }
      
      return CGFloat((keyboardWidth - totalSpace) / Double(keysInRow))
    }
    
    return keyboardRowKeyWidths.min() ?? .zero
  }
  
  private func setupKeyboard(keyWidth: CGFloat = getPortraitModeKeyWidth()) {
    backgroundColor = .tertiarySystemFill
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
    ])
    
    mainStackView.removeAllArrangedSubviews()
    
    type(of: self).keyboardLayout.enumerated().forEach { index, row in
      let keyboardRow = KeyboardRow()
      keyboardRow.delegate = delegate
      
      let isLastRow = index == type(of: self).keyboardLayout.count - 1
      
      let keyRowRefs = keyboardRow.configure(keys: row, keyWidth: keyWidth, isLastRow: isLastRow)
      
      keyReferences.append(contentsOf: keyRowRefs)
      
      mainStackView.addArrangedSubview(keyboardRow)
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
