//
//  KeyboardRow.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/3/22.
//

import UIKit

final class KeyboardRow: UIStackView {
  public struct Layout {
    static let interKeySpacing = 0.0
    static let specialKeySpacing = 4.0
    static let specialKeyWidthMultiplier = 1.5
    static let heightToWidthRatio = 1.5
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
  func configure(keys: [WordleKeyboardKey], keyWidth: CGFloat) -> [WeakRef<WordleKeyboardKey>]{
    var keyReferences: [WeakRef<WordleKeyboardKey>] = []
    
    keys.enumerated().forEach { index, keyView in
      keyView.delegate = delegate
      switch keyView.keyType {
        case .char(_):
          keyReferences.append(WeakRef(value: keyView))
          keyView.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
        case .submit, .del:
          keyView.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
          setCustomSpacing(Layout.specialKeySpacing, after: keyView)
        case .forfeit(_), .mainMenu, .nextClue, .endGame:
          break
      }
      
      addArrangedSubview(keyView)
    }
    
    heightAnchor.constraint(equalToConstant: keyWidth * Layout.heightToWidthRatio).isActive = true
    
    return keyReferences
  }
}
