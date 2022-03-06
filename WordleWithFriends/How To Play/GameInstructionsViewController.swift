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
    stackView.spacing = 8.0
    
    return stackView
  }()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    return scrollView
  }()
  
  private lazy var instructionsHeader: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text =
"""
Guess the clue in six tries.

Each guess must be a valid word. Hit the enter button to submit.

After each guess, the color of the tiles will change to show how close your guess was to the word.
"""
    
    label.numberOfLines = 0
    
    return label
  }()
  
  private lazy var horizontalSeparator: HorizontalSeparatorView = {
    let sv = HorizontalSeparatorView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()
  
  private lazy var headerLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Examples"
    label.font = UIFont.boldSystemFont(ofSize: 18.0)
    
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
    let boldOString = NSAttributedString(string: "O", attributes: [.font: UIFont.boldSystemFont(ofSize: 16.0)])
    label.attributedText = "The letter ".append(boldOString).append(" is in the correct place.")
    
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
    let boldOString = NSAttributedString(string: "L", attributes: [.font: UIFont.boldSystemFont(ofSize: 16.0)])
    label.attributedText = "The letter ".append(boldOString).append(" is in the clue but in the wrong place.")
    
    return label
  }()
  
  private lazy var incorrectGuessExampleRow: WordGuessRowView = {
    let row = WordGuessRowView()
    var guess = WordGuess(guess: "PARKS")
    guess.mark(2, as: .incorrect)
    row.configure(with: guess)
    
    return row
  }()
  
  private lazy var incorrectGuessExplanation: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    let boldOString = NSAttributedString(string: "R", attributes: [.font: UIFont.boldSystemFont(ofSize: 16.0)])
    label.attributedText = "The letter ".append(boldOString).append(" is not in the clue.")
    
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
    stackView.addArrangedSubview(horizontalSeparator)
    stackView.addArrangedSubview(headerLabel)
    stackView.addArrangedSubview(correctGuessExampleRow)
    stackView.addArrangedSubview(correctGuessExplanation)
    stackView.addArrangedSubview(misplacedGuessExampleRow)
    stackView.addArrangedSubview(misplacedGuessExplanation)
    stackView.addArrangedSubview(incorrectGuessExampleRow)
    stackView.addArrangedSubview(incorrectGuessExplanation)
    
    
    
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
