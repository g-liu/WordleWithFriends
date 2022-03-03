//
//  WordleKeyboardInputView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/2/22.
//

import Foundation
import UIKit

final class WordleKeyboardInputView: UIView {
  // TODO make customizable
  private static let keyboardLayout = [[
    "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P",
  ], [
    "A", "S", "D", "F", "G", "H", "J", "K", "L",
  ], [
    "Z", "X", "C", "V", "B", "N", "M",
  ]]
  
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
    
    type(of: self).keyboardLayout.forEach { row in
      let stackView = UIStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.spacing = 2.0
      stackView.axis = .horizontal
      stackView.alignment = .fill
      
      row.forEach { key in
        let keyView = WordleKeyboardKey()
        keyView.char = Character(key)
        stackView.addArrangedSubview(keyView)
      }
      
      mainStackView.addArrangedSubview(stackView)
      
    }
    
    addSubview(mainStackView)
    mainStackView.pin(to: safeAreaLayoutGuide, margins: UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8))
  }
}
/*
extension WordleKeyboardInputView: UIKeyInput {
  var hasText: Bool {
    <#code#>
  }
  
  func insertText(_ text: String) {
    <#code#>
  }
  
  func deleteBackward() {
    <#code#>
  }
  
  
}
*/
