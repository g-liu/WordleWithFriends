//
//  GameInstructionsViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/5/22.
//

import UIKit

final class GameInstructionsViewController: UIViewController {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .top
    stackView.spacing = 16.0
    
    return stackView
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    return scrollView
  }()
  
  private lazy var instructionsHeader: UILabel = {
    // TODO: Pluralization?
    let numberOfAttemptsText = "\(GameSettings.maxGuesses.readIntValue().spelledOut ?? " ") tries".bolded
    let clueLengthText = "\(GameSettings.clueLength.readIntValue().spelledOut ?? " ")-letter".bolded
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.attributedText = "Guess the clue in "
      .appending(numberOfAttemptsText)
      .appending(" or less. The clue will be a ")
      .appending(clueLengthText)
      .appending(" word.")

    label.numberOfLines = 0
    
    return label
  }()
  
  private lazy var headerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Examples"
    label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
    
    return label
  }()
  
  private lazy var correctGuessExampleRow: WordGuessRowView = {
    let row = WordGuessRowView()
    var guess = WordGuess(guess: "GEOFF")
    guess.mark(2, as: .correct)
    row.configure(with: guess)
    
    return row
  }()
  
  private lazy var correctGuessExplanation: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.attributedText = "The letter ".appending("O".bolded).appending(" is in the correct place.".asAttributedString)
    
    return label
  }()
  
  private lazy var misplacedGuessExampleRow: WordGuessRowView = {
    let row = WordGuessRowView()
    var guess = WordGuess(guess: "APPLE")
    guess.mark(3, as: .misplaced)
    row.configure(with: guess)
    
    return row
  }()
  
  private lazy var misplacedGuessExplanation: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.attributedText = "The letter ".appending("L".bolded).appending(" is in the clue but in the wrong place.".asAttributedString)
    
    return label
  }()
  
  private lazy var incorrectGuessExampleRow: WordGuessRowView = {
    let row = WordGuessRowView()
    var guess = WordGuess(guess: "PARKS")
    guess.mark(0, as: .incorrect)
    row.configure(with: guess)
    
    return row
  }()
  
  private lazy var incorrectGuessExplanation: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.attributedText = "The letter ".appending("P".bolded).appending(" is not in the clue.".asAttributedString)
    
    return label
  }()
  
  private lazy var settingsTeaser: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.attributedText = "✨ Pro tip! ".bolded.appending("You can change stuff like the number of guesses in the Settings.\n\n") // TODO: deeplink to settings
    
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TODO: Factor some of this out as it's shared with GameSettingsVC
    title = "How to play Wordle"
    navigationItem.title = "How to play Wordle"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    
    view.backgroundColor = .systemBackground
    
    stackView.addArrangedSubview(instructionsHeader)
    stackView.addArrangedSubview(HorizontalSeparatorView())
    stackView.addArrangedSubview(headerLabel)
    stackView.addArrangedSubview(correctGuessExampleRow)
    stackView.addArrangedSubview(correctGuessExplanation)
    stackView.addArrangedSubview(misplacedGuessExampleRow)
    stackView.addArrangedSubview(misplacedGuessExplanation)
    stackView.addArrangedSubview(incorrectGuessExampleRow)
    stackView.addArrangedSubview(incorrectGuessExplanation)
    stackView.addArrangedSubview(HorizontalSeparatorView())
    stackView.addArrangedSubview(settingsTeaser)
    
    
    scrollView.addSubview(stackView)
    stackView.pin(to: scrollView, margins: .init(top: 0, left: 16, bottom: 0, right: 16))
    stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    
    view.addSubview(scrollView)
    scrollView.pin(to: view.safeAreaLayoutGuide)
    
  }
  
  @objc private func didTapClose() {
    dismiss(animated: true)
  }
}
