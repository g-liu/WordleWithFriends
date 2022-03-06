//
//  WordInputTextField.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordInputTextField: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    layer.borderWidth = 1.0
    layer.borderColor = UIColor.separator.cgColor
    autocapitalizationType = .allCharacters
    autocorrectionType = .no
    font = .monospacedSystemFont(ofSize: 38, weight: .bold)
    keyboardType = .asciiCapable
    textAlignment = .center
  }
  
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    false
  }
  
  override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
    []
  }
  
//  override func caretRect(for position: UITextPosition) -> CGRect {
//    .zero
//  }
  
  override func closestPosition(to point: CGPoint) -> UITextPosition? {
    let beginning = self.beginningOfDocument
    let end = self.position(from: beginning, offset: self.text?.count ?? 0)
    return end
  }
}
