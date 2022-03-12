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
  private var guessActions: [GuessAction] = .init() {
    didSet {
      if numCompletedClues > highScore {
        highScore = numCompletedClues
      }
    }
  }
  
  var personalBest = UserDefaults.standard.integer(forKey: "gameStats.highScore")
  
  var statistics: GameStatistics {
    .init(averageTimePerCompletedClue: averageTimePerCorrectClue,
          averageTimePerSkippedClue: averageTimePerSkippedClue,
          averageGuessesPerCompletedClue: averageGuessesPerCorrectClue,
          averageGuessesPerSkippedClue: averageGuessesPerSkippedClue,
          lowestGuessesForCompletedClue: lowestGuessesForCorrectClue,
          highestGuessesForCompletedClue: highestGuessesForCorrectClue,
          numCompletedClues: numCompletedClues,
          numSkippedClues: numSkippedClues,
          totalGuesses: totalGuesses,
          personalBest: personalBest)
  }
  
  var numCompletedClues: Int {
    correctClueAttempts.count
  }
  
  private var numSkippedClues: Int {
    skippedClueAttempts.count
  }
  
  var numGivenClues: Int {
    attemptsPerClue.count
  }
  
  private var totalGuesses: Int {
    guessActions.filter { $0.outcome != .skipped }.count
  }
  
  private var averageTimePerCorrectClue: Double {
    guard numCompletedClues > 0 else { return 0 }
    
    let totalTimeTaken = correctClueAttempts.reduce(0) { $0 + $1.totalTimeElapsed }
    
    return totalTimeTaken / numCompletedClues
  }
  
  private var averageTimePerSkippedClue: Double {
    guard numSkippedClues > 0 else { return 0 }
    
    let totalTimeTaken = skippedClueAttempts.reduce(0) { $0 + $1.totalTimeElapsed }
    
    return totalTimeTaken / numSkippedClues
  }
  
  private var averageGuessesPerCorrectClue: Double {
    guard numCompletedClues > 0 else { return 0.0 }
    
    let totalGuessesTaken = correctClueAttempts.reduce(0.0) { $0 + $1.numGuesses }
    
    return totalGuessesTaken / numCompletedClues
  }
  
  private var averageGuessesPerSkippedClue: Double {
    guard numSkippedClues > 0 else { return 0.0 }
    
    let totalGuessesTaken = skippedClueAttempts.reduce(0.0) { $0 + $1.numGuesses }
    
    return totalGuessesTaken / numSkippedClues
  }
  
  private var lowestGuessesForCorrectClue: Int {
    guard let min = correctClueAttempts.min(by: { $0.numGuesses < $1.numGuesses }) else { return 0 }
    
    return min.numGuesses
  }
  
  private var highestGuessesForCorrectClue: Int {
    guard let max = correctClueAttempts.max(by: { $0.numGuesses < $1.numGuesses }) else { return 0 }
    
    return max.numGuesses
  }
  
  private var attemptsPerClue: [ClueAttempt] {
    var guessActions = guessActions
    if guessActions.last?.outcome == .incorrect {
      // This condition is triggered if the user is still working on guessing a clue when the timer runs out
      guessActions.append(.init(timeRemaining: 0, outcome: .skipped))
    }
    let result1 = guessActions.splitIncludeDelimiter { action in
      action.outcome == .correct || action.outcome == .skipped
    }
    
    let result2 = result1.compactMap { actionsPerClue -> ClueAttempt? in
      guard let timeOfFirstGuess = actionsPerClue.first?.timeRemaining,
            let timeOfLastGuess = actionsPerClue.last?.timeRemaining,
            let outcome = actionsPerClue.last?.outcome else { return nil }
  
      let totalTimeElapsed = timeOfFirstGuess - timeOfLastGuess
      // A skip in and of itself does not count as a guess. The attempts before it will be counted in the number of guesses.
      let numGuesses = outcome == .skipped ? actionsPerClue.count - 1 : actionsPerClue.count
      
      return .init(numGuesses: numGuesses, outcome: outcome, totalTimeElapsed: totalTimeElapsed)
    }
    
    return result2
  }
  
  private var correctClueAttempts: [ClueAttempt] {
    attemptsPerClue.filter { $0.outcome == .correct }
  }
  
  private var skippedClueAttempts: [ClueAttempt] {
    attemptsPerClue.filter { $0.outcome == .skipped }
  }
  
  private(set) var highScore: Int {
    get { UserDefaults.standard.integer(forKey: "gameStats.highScore") }
    set {
      UserDefaults.standard.set(newValue, forKey: "gameStats.highScore")
    }
  }
  
  var isPersonalBest: Bool { highScore > personalBest }
  
  mutating func logClueGuess(timeRemaining: TimeInterval, outcome: GuessOutcome) {
    guessActions.append(.init(timeRemaining: timeRemaining, outcome: outcome))
  }
}

struct ClueAttempt {
  let numGuesses: Int
  let outcome: GuessOutcome
  let totalTimeElapsed: TimeInterval
}

struct GameStatistics {
  let averageTimePerCompletedClue: Double
  let averageTimePerSkippedClue: Double
  var averageTimePerClue: Double {
    guard totalClues > 0 else { return 0 }
    return (averageTimePerCompletedClue * numCompletedClues + averageTimePerSkippedClue * numSkippedClues) / totalClues
  }
  
  let averageGuessesPerCompletedClue: Double
  let averageGuessesPerSkippedClue: Double
  var averageGuessesPerClue: Double {
    guard totalClues > 0 else { return 0 }
    return (averageGuessesPerCompletedClue * numCompletedClues + averageGuessesPerSkippedClue * numSkippedClues) / totalClues
  }
  
  let lowestGuessesForCompletedClue: Int
  let highestGuessesForCompletedClue: Int
  
  let numCompletedClues: Int
  let numSkippedClues: Int
  var totalClues: Int { numCompletedClues + numSkippedClues }
  
  var percentCompleted: Double {
    guard totalClues > 0 else { return 0 }
    return round((numCompletedClues.asDouble / totalClues) * 100)
  }
  
  let totalGuesses: Int
  
  let personalBest: Int
  
  var isNewPersonalBest: Bool { numCompletedClues > personalBest }
}

enum GuessOutcome {
  case correct
  case incorrect
  case skipped
}

struct GuessAction {
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
    label.text = "GUESSED: 0 / 0"
    
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
  
  var statistics: GameStatistics { tracker.statistics }
  
  private var countdownTimer: Timer?
  
  private let refreshRate: Int = 10
  
  var delegate: TimeTrialGameProtocol?
  
  // TODO: Move to model w/delegate to update?
  var secondsRemaining: TimeInterval = 0 {
    didSet {
      countdownLabel.text = "\(ceil(secondsRemaining).asString(style: .positional))"
      
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
  
  private func updateBar() {
    completedCluesLabel.text = "GUESSED: \(tracker.numCompletedClues) / \(tracker.numGivenClues)"
    highScoreLabel.text = "HIGH SCORE: \(tracker.highScore)"
  }
  
  @objc private func advanceTimer(_ sender: Timer?) {
    secondsRemaining -= refreshRate.inverse
  }
}
