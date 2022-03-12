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
  case mainMenu
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
          // NOTE: GIVE UP KEY SHOULD BE RENAMED IN TIME TRIAL MODE
          // Maybe create a key to "end time trial immediately"
          // and another key to next clue (reuse Give Up for this with much shorter delay??)
          // no main menu...
          setTitle("Give up", for: .normal)
          setTitleColor(.systemFill, for: .disabled)

          contentEdgeInsets.left = 8
          contentEdgeInsets.right = 8
          
          addTarget(self, action: #selector(didBeginLongPressKey), for: .touchDown)
          
          let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressKey))
          longPressGestureRecognizer.minimumPressDuration = minDuration
          addGestureRecognizer(longPressGestureRecognizer)
          
          if let backgroundView = backgroundView {
            insertSubview(progressBar, aboveSubview: backgroundView)
          } else {
            addSubview(progressBar)
            sendSubviewToBack(progressBar)
          }
          progressBar.pin(to: self, margins: .init(top: 4, left: 1.5, bottom: 4, right: 1.5))
          
          progressBar.isHidden = true
          
          titleLabel?.font = titleLabel?.font.withSize(22.0)
        case .mainMenu:
          setTitle("Main menu", for: .normal)
          
          contentEdgeInsets.left = 8
          contentEdgeInsets.right = 8
          
          titleLabel?.font = titleLabel?.font.withSize(22.0)
      }
    }
  }
  
  private var guessState: LetterState = .unchecked {
    didSet {
      backgroundView?.backgroundColor = guessState.associatedColor
    }
  }
  
  private var backgroundView: UIView?
  
  private var progressBarTimer: Timer?
  private var timerFireCount: Int = 0
  
  private lazy var progressBar: UIProgressView = {
    let bar = UIProgressView()
    bar.translatesAutoresizingMaskIntoConstraints = false
    bar.trackTintColor = .clear
    
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
    
    let backgroundSubview = UIView()
    backgroundSubview.translatesAutoresizingMaskIntoConstraints = false
    backgroundSubview.layer.cornerRadius = 4.0
    backgroundSubview.isOpaque = true
    backgroundSubview.backgroundColor = guessState.associatedColor
    self.backgroundView = backgroundSubview

    insertSubview(backgroundSubview, belowSubview: progressBar)
    backgroundSubview.pin(to: self, margins: .init(top: 4, left: 1.5, bottom: 4, right: 1.5))
    
    sendSubviewToBack(backgroundSubview)
    backgroundSubview.isUserInteractionEnabled = false
    
    titleLabel?.font = titleLabel?.font.withSize(24.0)
    titleLabel?.numberOfLines = 1
    setTitleColor(.label, for: .normal)
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
      case .mainMenu:
        delegate?.didTapMainMenu()
        AudioServicesPlaySystemSound(1156)
        
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
    
    removeGestureRecognizer(gestureRecognizer)
    
    resetGiveUpProgress()

    AudioServicesPlaySystemSound(1156)
  }
}
