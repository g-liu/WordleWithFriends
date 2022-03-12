//
//  TimeTrialStatsBar.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/11/22.
//

import UIKit

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
    label.text = "GUESSED: 0"
    
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
  
  private var countdownTimer: Timer?
  
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
      // Calculate intrinsicContentSize that will fit all the text
    let textSize = stackView.sizeThatFits(.init(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude))
    return CGSize(width: self.bounds.width, height: textSize.height)
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
//    translatesAutoresizingMaskIntoConstraints = false
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
  
  @objc private func advanceTimer(_ sender: Timer?) {
    secondsRemaining -= 1
  }
}