//
//  KeyboardRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/3/22.
//

import UIKit

final class KeyboardRow: UIStackView {
  public struct Layout {
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
  // TODO: Get rid of this config and just accept the raw keys as input
  // Then we don't have to worry about `isLastAlphaRow`
  func configure(keys: [Character], keyWidth: CGFloat, isLastAlphaRow: Bool = false) -> [WeakRef<WordleKeyboardKey>]{
    self.configure(keys: keys.map { WordleKeyboardKey(keyType: .char($0)) }, keyWidth: keyWidth, isLastAlphaRow: isLastAlphaRow)
  }
  
  @discardableResult
  func configure(keys: [WordleKeyboardKey], keyWidth: CGFloat, isLastAlphaRow: Bool = false) -> [WeakRef<WordleKeyboardKey>]{
    var keyReferences: [WeakRef<WordleKeyboardKey>] = []
    
    if isLastAlphaRow {
      // last row must add Enter key (Submit guess)
      let enterKey = WordleKeyboardKey(keyType: .submit)
      enterKey.delegate = delegate
      enterKey.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
      addArrangedSubview(enterKey)
      setCustomSpacing(Layout.specialKeySpacing, after: enterKey)
    }
    
    keys.enumerated().forEach { index, keyView in
      keyView.delegate = delegate
      keyView.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
      addArrangedSubview(keyView)
      
      keyReferences.append(WeakRef(value: keyView))
    }
    
    if isLastAlphaRow {
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
