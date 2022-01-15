//
//  GameMessageView.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/15/22.
//

import UIKit

final class GameMessageView: UIView {
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = 8.0
    stackView.alignment = .center
    
    return stackView
  }()
  
  private lazy var gameMessageLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textAlignment = .center
    label.isHidden = true
    
    return label
  }()
  
  private lazy var tryAgainButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Play again", for: .normal)
    button.setTitleColor(.systemGreen, for: .normal)
    button.addTarget(self, action: #selector(didTapPlayAgain), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    button.isEnabled = false
    
    return button
  }()
  
  var playAgain: (() -> Void)? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupView()
  }
  
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    addSubview(gameMessageLabel)
    addSubview(tryAgainButton)
    
    NSLayoutConstraint.activate([
      gameMessageLabel.topAnchor.constraint(equalTo: topAnchor),
      gameMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      gameMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      tryAgainButton.topAnchor.constraint(equalTo: gameMessageLabel.bottomAnchor),
      tryAgainButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      tryAgainButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      tryAgainButton.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  func showWin() {
    isHidden = false
    gameMessageLabel.text = "Congratulations, you guessed the word!"
  }
  
  func showLose(answer: String) {
    isHidden = false
    gameMessageLabel.text = "Oh no, you didn't guess the word! It was \(answer)."
  }
  
  func hide() {
    isHidden = true
    gameMessageLabel.text = ""
  }
  
  @objc private func didTapPlayAgain() {
    playAgain?()
  }
}
