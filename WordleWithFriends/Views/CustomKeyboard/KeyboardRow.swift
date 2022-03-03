//
//  KeyboardRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/3/22.
//

import UIKit

final class KeyboardRow: UIStackView {
  struct Layout {
    static let interKeySpacing = 4.0
    static let specialKeySpacing = 8.0
    static let specialKeyWidthMultiplier = 1.5
    static let heightToWidthRatio = 1.4
  }
  
  var delegate: KeyTapDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    spacing = Layout.interKeySpacing
    axis = .horizontal
    alignment = .fill
  }
  
  @discardableResult
  func configure(keys: [Character], keyWidth: CGFloat, isLastRow: Bool = false) -> [WeakRef<WordleKeyboardKey>]{
    var keyReferences: [WeakRef<WordleKeyboardKey>] = []
    
    if isLastRow {
      // last row must add Enter key (Submit guess)
      let enterKey = WordleKeyboardKey(keyType: .submit)
      enterKey.delegate = delegate
      enterKey.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
      addArrangedSubview(enterKey)
      setCustomSpacing(Layout.specialKeySpacing, after: enterKey)
    }
    
    keys.enumerated().forEach { index, char in
      let keyView = WordleKeyboardKey(keyType: .char(char))
      keyView.delegate = delegate
      keyView.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
      addArrangedSubview(keyView)
      
      keyReferences.append(WeakRef(value: keyView))
    }
    
    if isLastRow {
      if let lastKey = arrangedSubviews.last {
        setCustomSpacing(Layout.specialKeySpacing, after: lastKey)
      }
      // last row must add Backspace key
      let backspaceKey = WordleKeyboardKey(keyType: .del)
      backspaceKey.delegate = delegate
      backspaceKey.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
      addArrangedSubview(backspaceKey)
    }
    
    heightAnchor.constraint(equalToConstant: keyWidth * Layout.heightToWidthRatio).isActive = true
    
    return keyReferences
  }
}
