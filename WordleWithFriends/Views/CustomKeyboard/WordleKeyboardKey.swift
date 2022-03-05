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
  case forfeit(Double)
}

final class WordleKeyboardKey: UIButton {
  var keyType: KeyType = .char(" ") /* NB: The initial value is only a placeholder */ {
    didSet {
      switch keyType {
        case .char(let character):
          setTitle("\(character)", for: .normal)
        case .submit:
          setTitle("⏎", for: .normal)
        case .del:
          setTitle("⌫", for: .normal)
        case .forfeit(let minDuration):
          setTitle("Give up", for: .normal)
          setTitleColor(.systemFill, for: .disabled)

          contentEdgeInsets.left = 8
          contentEdgeInsets.right = 8
          
          addTarget(self, action: #selector(didBeginLongPressKey), for: .touchDown)
          
          let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressKey))
          longPressGestureRecognizer.minimumPressDuration = minDuration
          addGestureRecognizer(longPressGestureRecognizer)
          
          addSubview(progressBar)
          progressBar.pin(to: self)
          progressBar.trackTintColor = .clear
          sendSubviewToBack(progressBar)
          progressBar.isHidden = true
      }
    }
  }
  
  private var guessState: LetterState = .unchecked {
    didSet {
      backgroundColor = guessState.associatedColor // TODO verify
    }
  }
  
  private var progressBarTimer: Timer?
  private var timerFireCount: Int = 0
  
  private lazy var progressBar: UIProgressView = {
    let bar = UIProgressView()
    bar.translatesAutoresizingMaskIntoConstraints = false
    bar.heightAnchor.constraint(equalToConstant: 4.0).isActive = true
    
    return bar
  }()
  
  var delegate: KeyTapDelegate?
  
  init(keyType: KeyType) {
    defer {
      // defer is necessary here to trigger the `didSet`
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
  
  @objc private func didTapKey(_ sender: UIButton, event: UIEvent) {
    guard let touchLocation = event.allTouches?.first?.location(in: sender),
          sender.bounds.contains(touchLocation) else { return }
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
        resetGiveUpProgress()
        
        break // the actual action is handled by long-press
    }
  }
  
  private func resetGiveUpProgress() {
    progressBar.progress = 0.0
    timerFireCount = 0
    progressBarTimer?.invalidate()
    progressBar.isHidden = true
  }
  
  @objc private func didBeginLongPressKey() {
    // begin progress bar animation
    progressBarTimer = Timer.scheduledTimer(timeInterval: TimeInterval(UIScreen.main.maximumFramesPerSecond.inverse), target: self, selector: #selector(shouldUpdateProgressBar), userInfo: nil, repeats: true)
    progressBar.isHidden = false
  }
  
  @objc private func shouldUpdateProgressBar() {
    guard case KeyType.forfeit(let minDuration) = keyType else { return }
    timerFireCount += 1
    progressBar.progress = Float((UIScreen.main.maximumFramesPerSecond.inverse * timerFireCount) / minDuration)
  }
  
  @objc private func didLongPressKey(_ gestureRecognizer: UIGestureRecognizer) {
    delegate?.didForfeit()
    
    resetGiveUpProgress()

    AudioServicesPlaySystemSound(1156)
  }
}
