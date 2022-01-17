//
//  GameMessagingViewController.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

final class GameMessagingViewController: UIViewController {
  var delegate: GameEndDelegate?
  
  private lazy var alertController: UIAlertController = {
    let vc = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    return vc
  }()
  
  private lazy var shareButton: UIAlertAction = {
    let action = UIAlertAction(title: "Share", style: .cancel) { [weak self] _ in
      self?.delegate?.copyResult()
    }
    
    return action
  }()
  
  private lazy var playAgainButton: UIAlertAction = {
    let action = UIAlertAction(title: "Play again", style: .default) { [weak self] _ in
      self?.delegate?.goToInitialScreen()
    }
    
    return action
  }()
  
  func showWin(numGuesses: Int) {
    alertController.title = "Congratulations!"
    if numGuesses == 1 {
      alertController.message = "You guessed the word in \(numGuesses) try."
    } else {
      alertController.message = "You guessed the word in \(numGuesses) tries."
    }
    
    alertController.addAction(shareButton)
    alertController.addAction(playAgainButton)
    
    present(alertController, animated: true) { [weak self] in
      guard let self = self else { return }
      self.alertController.view.superview?.isUserInteractionEnabled = true
      self.alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.shouldDismiss)))
    }
  }
  
  func showLose(clue: String) {
    alertController.title = "Aww 😢"
    alertController.message = "The actual word was \(clue). Good try!"
    
    alertController.addAction(shareButton)
    alertController.addAction(playAgainButton)
    
    present(alertController, animated: true)
  }
  
  @objc private func shouldDismiss() {
    alertController.dismiss(animated: true)
  }
}
