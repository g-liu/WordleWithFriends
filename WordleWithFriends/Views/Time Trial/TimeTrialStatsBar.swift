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

struct TimeTrialTracker {
  private var timestamps: [GuessTimestamp] = .init() {
    didSet {
      if numCompletedClues > highScore {
        highScore = numCompletedClues
      }
    }
  }
  
  var numCompletedClues: Int {
    timestamps.filter { $0.outcome == .correct }.count
  }
  
  var numSkippedClues: Int {
    timestamps.filter { $0.outcome == .incorrect }.count
  }
  
  var highScore: Int {
    get { UserDefaults.standard.integer(forKey: "gameStats.highScore") }
    set {
      UserDefaults.standard.set(newValue, forKey: "gameStats.highScore")
    }
  }
  
  mutating func logClueGuess(timeRemaining: TimeInterval, outcome: GuessOutcome) {
    timestamps.append(.init(timeRemaining: timeRemaining, outcome: outcome))
  }
}

enum GuessOutcome {
  case correct
  case incorrect
  case skipped
}

struct GuessTimestamp {
  let timeRemaining: TimeInterval
  let outcome: GuessOutcome
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
  
  private lazy var completedCluesLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    label.text = "GUESSED: 0"
    
    return label
  }()
  
  // TODO: Button in settings to clear this
  private lazy var highScoreLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: UIFont.systemFontSize)
    label.text = "HIGH SCORE:"
    
    return label
  }()
  
  private var tracker: TimeTrialTracker = .init()
  
  private var countdownTimer: Timer?
  
  var delegate: TimeTrialGameProtocol?
  
  // TODO: Move to model w/delegate to update?
  var secondsRemaining: TimeInterval = 0 {
    didSet {
      countdownLabel.text = "\(secondsRemaining.asString(style: .positional))"
      
      if secondsRemaining == 0 {
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
    countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(advanceTimer(_:)), userInfo: nil, repeats: true)
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
  
  private func updateBar() {
    completedCluesLabel.text = "GUESSED: \(tracker.numCompletedClues)"
    highScoreLabel.text = "HIGH SCORE: \(tracker.highScore)"
  }
  
  @objc private func advanceTimer(_ sender: Timer?) {
    secondsRemaining -= 1
  }
}
