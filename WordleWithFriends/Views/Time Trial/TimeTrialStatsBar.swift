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
  private static let guessedCluesFormatString = "GUESSED: %d / %d"
  private static let highScoreFormatString = "HIGH SCORE: %d"
  
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView().autolayoutEnabled
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.alignment = .fill
    stackView.spacing = 12.0
    
    return stackView
  }()
  
  private lazy var countdownLabel: UILabel = {
    let label = UILabel().autolayoutEnabled
    label.textColor = .label
    label.numberOfLines = 1
    label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
    
    return label
  }()
  
  private lazy var completedCluesLabel: UILabel = {
    let label = UILabel().autolayoutEnabled
    label.textColor = .label
    label.numberOfLines = 1
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    
    return label
  }()
  
  // TODO: Button in settings to clear this
  private lazy var highScoreLabel: UILabel = {
    let label = UILabel().autolayoutEnabled
    label.textColor = .label
    label.numberOfLines = 1
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    
    return label
  }()
  
  // TODO: Stats button at end of game to show stats
  
  private var tracker: TimeTrialTracker
  
  var statistics: GameStatistics { tracker.statistics }
  
  private var countdownTimer: Timer?
  
  private let refreshRate: Int = 10
  
  var delegate: TimeTrialGameProtocol?
  
  private var secondsRemaining: TimeInterval = 0 {
    didSet {
      countdownLabel.text = "\(ceil(secondsRemaining).asMinutesSeconds)"
      
      if secondsRemaining <= 0 {
        countdownTimer?.invalidate()
        delegate?.timerDidExpire()
        backgroundColor = .systemRed
      } else {
        backgroundColor = .systemBrown
      }
    }
  }
  
  override var intrinsicContentSize: CGSize {
    let sizeThatFits = sizeThatFits(.init(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
    return CGSize(width: bounds.width, height: sizeThatFits.height)
  }
  
  init(initialTimeRemaining: TimeInterval) {
    tracker = .init(initialTimeRemaining: initialTimeRemaining)
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
  
  func restartCountdown() {
    countdownTimer?.invalidate()
    secondsRemaining = tracker.initialTimeRemaining
    countdownTimer = Timer.scheduledTimer(timeInterval: refreshRate.inverse, target: self, selector: #selector(advanceTimer(_:)), userInfo: nil, repeats: true)
  }
  
  func trackCorrectGuess(guess: String) {
    guard !tracker.didLogEndGame else { return }
    tracker.logAction(timeRemaining: secondsRemaining, outcome: .correct, actualClue: guess)
    
    updateBar()
  }
  
  func trackSkip(actualClue: String) {
    guard !tracker.didLogEndGame else { return }
    tracker.logAction(timeRemaining: secondsRemaining, outcome: .skipped, actualClue: actualClue)
    
    updateBar()
  }
  
  func trackIncorrectGuess(guess: String, actualClue: String) {
    guard !tracker.didLogEndGame else { return }
    tracker.logAction(timeRemaining: secondsRemaining, outcome: .incorrect(guess: guess), actualClue: actualClue)
    
    updateBar()
  }
  
  func trackEndGame(actualClue: String) {
    guard !tracker.didLogEndGame else { return }
    tracker.logAction(timeRemaining: secondsRemaining, outcome: .endGame, actualClue: actualClue)
  }
  
  func resetBar() {
    tracker = .init(initialTimeRemaining: tracker.initialTimeRemaining)
    updateBar()
  }
  
  func forceTimerEnd() {
    secondsRemaining = 0
  }
  
  private func updateBar() {
    completedCluesLabel.text = String(format: type(of: self).guessedCluesFormatString, tracker.numCompletedClues, tracker.numGivenClues)
    highScoreLabel.text = String(format: type(of: self).highScoreFormatString, tracker.highScore)
  }
  
  @objc private func advanceTimer(_ sender: Timer?) {
    secondsRemaining -= refreshRate.inverse
  }
}
