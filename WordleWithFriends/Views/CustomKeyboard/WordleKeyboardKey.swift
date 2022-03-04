//
//  WordleKeyboardKey.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/2/22.
//

import Foundation
import UIKit
import AudioToolbox

enum KeyType {
  case char(Character)
  case submit
  case del
  case forfeit
}

final class WordleKeyboardKey: UIButton {
  var keyType: KeyType {
    didSet {
      switch keyType {
        case .char(let character):
          setTitle("\(character)", for: .normal)
        case .submit:
          setTitle("⏎", for: .normal)
        case .del:
          setTitle("⌫", for: .normal)
        case .forfeit:
          setTitle("Give up", for: .normal)

          contentEdgeInsets.left = 8
          contentEdgeInsets.right = 8
          
          let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressKey))
          longPressGestureRecognizer.minimumPressDuration = 1.5
          addGestureRecognizer(longPressGestureRecognizer)
      }
    }
  }
  
  private var guessState: LetterState = .unchecked {
    didSet {
      backgroundColor = guessState.associatedColor // TODO verify
    }
  }
  
  var delegate: KeyTapDelegate?
  
  init(keyType: KeyType) {
    // TODO: Hacky AF, any other way to trigger the didSet more gracefully?
    self.keyType = .del
    defer {
      self.keyType = keyType
    }
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    
    layer.cornerRadius = 3.0
    layer.masksToBounds = false
    backgroundColor = guessState.associatedColor
    
    titleLabel?.font = titleLabel?.font.withSize(24.0)
    titleLabel?.numberOfLines = 1
    addTarget(self, action: #selector(didTapKey), for: .touchUpInside)
  }
  
  func updateGuessState(_ state: LetterState) {
    guard state.priority > guessState.priority else { return }
    guessState = state
  }
  
  @objc private func didTapKey() {
    switch keyType {
      case .char(let character):
        delegate?.didTapKey(character)
        UIDevice.current.playInputClick()
      case .submit:
        delegate?.didTapSubmit()
        AudioServicesPlaySystemSound(1156)
      case .del:
        delegate?.didTapDelete()
        AudioServicesPlaySystemSound(1155)
      case .forfeit:
//        delegate?.didForfeit()
//        isEnabled = false
//        isHidden = true
//        AudioServicesPlaySystemSound(1156)
        break // handled by long-press
    }
  }
  
  @objc private func didLongPressKey(_ gestureRecognizer: UIGestureRecognizer) {
    delegate?.didForfeit()
    isEnabled = false
    isHidden = true
    AudioServicesPlaySystemSound(1156)
  }
}
