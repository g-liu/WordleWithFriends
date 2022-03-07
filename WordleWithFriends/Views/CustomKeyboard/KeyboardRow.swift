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
  func configure(keys: [WordleKeyboardKey], keyWidth: CGFloat) -> [WeakRef<WordleKeyboardKey>]{
    var keyReferences: [WeakRef<WordleKeyboardKey>] = []
    
    keys.enumerated().forEach { index, keyView in
      keyView.delegate = delegate
      switch keyView.keyType {
        case .char(_):
          keyView.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
        case .submit, .del:
          keyView.widthAnchor.constraint(equalToConstant: keyWidth * Layout.specialKeyWidthMultiplier).isActive = true
          setCustomSpacing(Layout.specialKeySpacing, after: keyView)
        case .forfeit(_), .mainMenu:
          break
      }
      
      addArrangedSubview(keyView)
      
      keyReferences.append(WeakRef(value: keyView))
    }
    
    heightAnchor.constraint(equalToConstant: keyWidth * Layout.heightToWidthRatio).isActive = true
    
    return keyReferences
  }
}
