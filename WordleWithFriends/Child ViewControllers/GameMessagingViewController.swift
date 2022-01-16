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
    let action = UIAlertAction(title: "Share", style: .default) { [weak self] _ in
      self?.delegate?.shareResult()
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
    alertController.message = "You guessed the word in \(numGuesses) tries." // TODO pluralize
    
    alertController.addAction(shareButton)
    alertController.addAction(playAgainButton)
    
    present(alertController, animated: true)
  }
  
  func showLose(actualWord: String) {
    alertController.title = "Aww 😢"
    alertController.message = "The actual word was \(actualWord). Good try!"
    
    alertController.addAction(shareButton)
    alertController.addAction(playAgainButton)
    
    present(alertController, animated: true)
  }
}
