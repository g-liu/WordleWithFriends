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
  func didForfeit()
  func didTapMainMenu()
}

final class WordleKeyboardInputView: UIInputView {
  private struct Layout {
    static let rowSpacing = 8.0
    static let topPadding = 8.0
  }
  private var keyReferences: [WeakRef<WordleKeyboardKey>] = []
  private weak var forfeitKey: WordleKeyboardKey?
  
  private static let keyboardLayout: [[WordleKeyboardKey]] = {
    let characterRows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
    var keyRows = characterRows.map { row in
      row.map {
        WordleKeyboardKey(keyType: .char($0))
      }
    }
    keyRows[keyRows.count-1].prepend(WordleKeyboardKey(keyType: .submit))
    keyRows[keyRows.count-1].append(WordleKeyboardKey(keyType: .del))
    
    return keyRows
  }()
  
  var delegate: KeyTapDelegate? {
    didSet {
      setupKeyboard()
    }
  }
  
  private let gamemode: GameMode
  
  init(gamemode: GameMode) {
    self.gamemode = gamemode
    super.init(frame: .zero, inputViewStyle: .keyboard)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.spacing = Layout.rowSpacing
    
    return stackView
  }()
  
  static func getPortraitModeKeyWidth() -> CGFloat {
    let keyboardWidth = UIScreen.main.bounds.width
    let keyboardRowKeyWidths = keyboardLayout.enumerated().map { index, row -> CGFloat in
      let totalSpace = row.reduce(0) { res, key in
        switch key.keyType {
          case .char(_), .forfeit(_), .mainMenu:
            return res + KeyboardRow.Layout.interKeySpacing
          case .del, .submit:
            return res + KeyboardRow.Layout.specialKeySpacing
        }
      } + KeyboardRow.Layout.interKeySpacing
      
      let keysInRow = row.reduce(0.0) { res, key in
        switch key.keyType {
          case .del, .submit:
            return res + KeyboardRow.Layout.specialKeyWidthMultiplier
          case .mainMenu, .forfeit(_):
            // TODO: This needs to be handled specially!!!
            return res + 1
          case .char(_):
            return res + 1
        }
      }
      
      return CGFloat((keyboardWidth - totalSpace) / keysInRow)
    }
    
    return keyboardRowKeyWidths.min() ?? .zero
  }
  
  func resetKeyboard() {
    setupKeyboard()
  }
  
  private func setupKeyboard(keyWidth: CGFloat = getPortraitModeKeyWidth()) {
    backgroundColor = .tertiarySystemFill
    translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width),
    ])
    
    mainStackView.removeAllArrangedSubviews()
    keyReferences = []
    
    type(of: self).keyboardLayout.enumerated().forEach { index, row in
      let keyboardRow = KeyboardRow()
      keyboardRow.delegate = delegate
      let keyRowRefs = keyboardRow.configure(keys: row, keyWidth: keyWidth)
      
      keyReferences.append(contentsOf: keyRowRefs)
      
      mainStackView.addArrangedSubview(keyboardRow)
    }
    
    if let lastSubview = mainStackView.arrangedSubviews.last {
      mainStackView.setCustomSpacing(16.0, after: lastSubview)
    }
    
    let forfeitKey = WordleKeyboardKey(keyType: .forfeit(0.75))
    self.forfeitKey = forfeitKey
    
    let mainMenuKey = WordleKeyboardKey(keyType: .mainMenu)
    
    let operationKeysRow = KeyboardRow()
    operationKeysRow.delegate = delegate
    if gamemode == .infinite {
      operationKeysRow.configure(keys: [forfeitKey, mainMenuKey], keyWidth: keyWidth)
    } else {
      operationKeysRow.configure(keys: [forfeitKey], keyWidth: keyWidth)
    }
    
    mainStackView.addArrangedSubview(operationKeysRow)
    
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
  
  func gameDidEnd() {
    forfeitKey?.isEnabled = false
  }
  
  func updateState(with wordGuess: WordGuess) {
    wordGuess.forEach { letterGuess in
      guard let guessAsciiValue = letterGuess.letter.asciiValue else { return }
      let indexInRefArray = Int(guessAsciiValue - (Character("A").asciiValue ?? 65))
      keyReferences[indexInRefArray].value?.updateGuessState(letterGuess.state)
    }
  }
}

extension WordleKeyboardInputView: UIInputViewAudioFeedback {
  var enableInputClicksWhenVisible: Bool { true }
}
