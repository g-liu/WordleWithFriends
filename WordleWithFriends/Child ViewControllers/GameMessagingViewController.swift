//
//  GameMessagingViewController.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

final class GameMessagingViewController: UIViewController {
  var delegate: GameEndDelegate?
  
  private lazy var alertController = DismissableAlertController(title: nil, message: nil, preferredStyle: .alert)
  
  private lazy var shareButton: UIAlertAction = {
    UIAlertAction(title: "Share", style: .default) { [weak self] _ in
      self?.delegate?.shareResult()
    }
  }()
  
  private lazy var playAgainButton: UIAlertAction = {
    UIAlertAction(title: "Play again", style: .default) { [weak self] _ in
      self?.delegate?.goToInitialScreen()
    }
  }()
  
  private lazy var newClueButton: UIAlertAction = {
    UIAlertAction(title: "New clue", style: .default) { [weak self] _ in
      self?.delegate?.restartWithNewClue()
    }
  }()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupVC()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupVC()
  }
  
  private func setupVC() {
    alertController.addAction(shareButton)
    alertController.addAction(playAgainButton)
    alertController.addAction(newClueButton)
  }
  
  func showWin(numGuesses: Int) {
    alertController.title = "Congratulations!"
    if numGuesses == 1 {
      alertController.message = "You guessed the word in \(numGuesses) try."
    } else {
      alertController.message = "You guessed the word in \(numGuesses) tries."
    }
    
    (navigationController?.topViewController ?? parent)?.present(alertController, animated: true)
  }
  
  func showLose(clue: String) {
    alertController.title = "Aww 😢"
    alertController.message = "The actual word was \(clue). Good try!"
    
    (navigationController?.topViewController ?? parent)?.present(alertController, animated: true)
  }
}
