//
//  TimeTrialStatsBar.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/11/22.
//

import UIKit

protocol TimeTrialGameProtocol {
  func timerDidExpire()
}

final class TimeTrialStatsBar: UIView {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill
    stackView.spacing = 12.0
    
    return stackView
  }()
  
  private lazy var countdownLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 1
    label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  private lazy var completedGuessesLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    label.text = "GUESSED: \(completedGuesses)"
    
    return label
  }()
  
  // TODO: Button in settings to clear this
  private lazy var highScore: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    label.text = "HIGH SCORE: 0"
    
    return label
  }()
  
  private var completedGuesses: Int = 0 {
    didSet {
      // TODO: Standardize label
      // TODO: Update highscore if exceeds
      completedGuessesLabel.text = "GUESSED: \(completedGuesses)"
    }
  }
  
  private var countdownTimer: Timer?
  
  var delegate: TimeTrialGameProtocol?
  
  // TODO: Move to model w/delegate to update?
  var secondsRemaining: TimeInterval = 0 {
    didSet {
      countdownLabel.text = "\(secondsRemaining.asString(style: .positional))"
      
      if secondsRemaining == 0 {
        countdownTimer?.invalidate()
      }
    }
  } // TODO: Configurable!
  
  override var intrinsicContentSize: CGSize {
    let sizeThatFits = sizeThatFits(.init(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
    return CGSize(width: bounds.width, height: sizeThatFits.height)
  }
  
  init() {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    autoresizingMask = .flexibleHeight
    backgroundColor = .systemBrown
    
    stackView.addArrangedSubview(completedGuessesLabel)
    stackView.addArrangedSubview(countdownLabel)
    stackView.addArrangedSubview(highScore)

    completedGuessesLabel.textAlignment = .left
    countdownLabel.textAlignment = .center
    highScore.textAlignment = .right
    
    completedGuessesLabel.setContentHuggingPriority(.required, for: .horizontal)
    countdownLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    highScore.setContentHuggingPriority(.required, for: .horizontal)
    
    addSubview(stackView)
    stackView.pin(to: safeAreaLayoutGuide, margins: .init(top: 8, left: 8, bottom: 8, right: 8))
  }
  
  func startCountdown() {
    countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(advanceTimer(_:)), userInfo: nil, repeats: true)
  }
  
  func trackCorrectGuess() {
    completedGuesses += 1
  }
  
  @objc private func advanceTimer(_ sender: Timer?) {
    secondsRemaining -= 1
  }
}
