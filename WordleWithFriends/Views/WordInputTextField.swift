//
//  WordInputTextField.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordInputTextField: UITextField {
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    false
  }
  
  override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
    []
  }
  
  override func caretRect(for position: UITextPosition) -> CGRect {
    .zero
  }
}
