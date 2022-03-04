//
//  KeyboardRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/3/22.
//

import UIKit

final class KeyboardRow {
  struct Layout {
    static let interKeySpacing = 4.0
    static let specialKeySpacing = 8.0
    static let specialKeyWidthMultiplier = 1.5
    static let heightToWidthRatio = 1.4
  }
  
  var delegate: KeyTapDelegate?
  private var keyReferences: [WeakRef<WordleKeyboardKey>] = []
  private var isLastRow: Bool = false
  private var keyWidth: CGFloat = 0.0
  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    setupView()
//  }
//
//  required init(coder: NSCoder) {
//    super.init(coder: coder)
//    setupView()
//  }
  
//  private func setupView() {
//    translatesAutoresizingMaskIntoConstraints = false
//    spacing = Layout.interKeySpacing
//    axis = .horizontal
//    alignment = .fill
//  }
  
  @discardableResult
  func configure(keys: [Character], keyWidth: CGFloat, isLastRow: Bool = false) -> [WeakRef<WordleKeyboardKey>] {
    keyReferences = []
    self.keyWidth = keyWidth
    self.isLastRow = isLastRow
    
//    if isLastRow {
//      // last row must add Enter key (Submit guess)
//      let enterKey = WordleKeyboardKey(keyType: .submit)
//      enterKey.delegate = delegate
//      enterKey.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
//      addArrangedSubview(enterKey)
//      setCustomSpacing(Layout.specialKeySpacing, after: enterKey)
//    }
    
    keys.enumerated().forEach { index, char in
      let keyView = WordleKeyboardKey(keyType: .char(char))
      keyView.delegate = delegate
      keyView.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
//      addArrangedSubview(keyView)
      
      keyReferences.append(WeakRef(value: keyView))
    }
    
//    if isLastRow {
//      if let lastKey = arrangedSubviews.last {
//        setCustomSpacing(Layout.specialKeySpacing, after: lastKey)
//      }
//      // last row must add Backspace key
//      let backspaceKey = WordleKeyboardKey(keyType: .del)
//      backspaceKey.delegate = delegate
//      backspaceKey.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
//      addArrangedSubview(backspaceKey)
//    }
    
//    heightAnchor.constraint(equalToConstant: keyWidth * Layout.heightToWidthRatio).isActive = true
    
    return keyReferences
  }
  
  func makeStackView() -> UIStackView {
    let arrangedSubviews = keyReferences.compactMap { $0.value }
    
    let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = Layout.interKeySpacing
    stackView.axis = .horizontal
    stackView.alignment = .fill
    
    if isLastRow {
      // last row must add Enter key (Submit guess)
      let enterKey = WordleKeyboardKey(keyType: .submit)
      enterKey.delegate = delegate
      enterKey.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
      stackView.insertArrangedSubview(enterKey, at: 0)
      stackView.setCustomSpacing(Layout.specialKeySpacing, after: enterKey)
      
      
      // last row must add Backspace key
      let backspaceKey = WordleKeyboardKey(keyType: .del)
      backspaceKey.delegate = delegate
      backspaceKey.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
      if let lastKey = stackView.arrangedSubviews.last {
        stackView.setCustomSpacing(Layout.specialKeySpacing, after: lastKey)
      }
      stackView.addArrangedSubview(backspaceKey)
    }
    
    stackView.heightAnchor.constraint(equalToConstant: keyWidth * Layout.heightToWidthRatio).isActive = true
    
    return stackView
    
  }
}
