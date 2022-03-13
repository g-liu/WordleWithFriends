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
  static let guessedCluesFormatString = "GUESSED: %d / %d"
  static let highScoreFormatString = "HIGH SCORE: %d"
  
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
  
  private lazy var completedCluesLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    
    return label
  }()
  
  // TODO: Button in settings to clear this
  private lazy var highScoreLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    
    return label
  }()
  
  // TODO: Stats button at end of game to show stats
  
  private var tracker: TimeTrialTracker = .init()
  
  var statistics: GameStatistics { tracker.statistics }
  
  private var countdownTimer: Timer?
  
  private let refreshRate: Int = 10
  
  var delegate: TimeTrialGameProtocol?
  
  // TODO: Move to model w/delegate to update?
  var secondsRemaining: TimeInterval = 0 {
    didSet {
      countdownLabel.text = "\(ceil(secondsRemaining).asString(style: .positional))"
      
      if secondsRemaining <= 0 {
        countdownTimer?.invalidate()
        delegate?.timerDidExpire()
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
  
  deinit {
    countdownTimer?.invalidate()
  }
  
  private func setupView() {
    autoresizingMask = .flexibleHeight
    backgroundColor = .systemBrown
    
    stackView.addArrangedSubview(completedCluesLabel)
    stackView.addArrangedSubview(countdownLabel)
    stackView.addArrangedSubview(highScoreLabel)

    completedCluesLabel.textAlignment = .left
    countdownLabel.textAlignment = .center
    highScoreLabel.textAlignment = .right
    
    completedCluesLabel.setContentHuggingPriority(.required, for: .horizontal)
    countdownLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    highScoreLabel.setContentHuggingPriority(.required, for: .horizontal)
    
    addSubview(stackView)
    stackView.pin(to: safeAreaLayoutGuide, margins: .init(top: 8, left: 8, bottom: 8, right: 8))
    
    updateBar()
  }
  
  func startCountdown() {
    countdownTimer?.invalidate()
    countdownTimer = Timer.scheduledTimer(timeInterval: refreshRate.inverse, target: self, selector: #selector(advanceTimer(_:)), userInfo: nil, repeats: true)
  }
  
  func trackCorrectGuess() {
    tracker.logClueGuess(timeRemaining: secondsRemaining, outcome: .correct)
    
    updateBar()
  }
  
  func trackSkip() {
    tracker.logClueGuess(timeRemaining: secondsRemaining, outcome: .skipped)
    
    updateBar()
  }
  
  func trackIncorrectGuess() {
    tracker.logClueGuess(timeRemaining: secondsRemaining, outcome: .incorrect)
    
    updateBar()
  }
  
  func resetBar() {
    tracker = .init()
    updateBar()
  }
  
  private func updateBar() {
    completedCluesLabel.text = String(format: type(of: self).guessedCluesFormatString, tracker.numCompletedClues, tracker.numGivenClues)
    highScoreLabel.text = String(format: type(of: self).highScoreFormatString, tracker.highScore)
  }
  
  @objc private func advanceTimer(_ sender: Timer?) {
    // TODO: This could possibly lead to floating point errors
    secondsRemaining -= refreshRate.inverse
  }
}
