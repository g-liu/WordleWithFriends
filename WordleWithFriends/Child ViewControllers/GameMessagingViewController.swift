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
  
  private lazy var mainMenuButton: UIAlertAction = {
    UIAlertAction(title: "", style: .default) { [weak self] _ in
      self?.delegate?.goToInitialScreen()
    }
  }()
  
  private lazy var newClueButton: UIAlertAction = {
    UIAlertAction(title: "New clue", style: .default) { [weak self] _ in
      self?.delegate?.restartWithNewClue()
    }
  }()
  
  private let gamemode: GameMode
  
  init(gamemode: GameMode) {
    self.gamemode = gamemode
    super.init(nibName: nil, bundle: nil)
    setupVC()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupVC() {
    alertController.addAction(shareButton)
    alertController.addAction(mainMenuButton)
    
    mainMenuButton.setValue("Main menu", forKeyPath: "title")
    
    switch gamemode {
      case .human:
        break
      case .computer:
        alertController.addAction(newClueButton)
      case .infinite:
        break // Infinite game mode never touches this VC
      case .timeTrial(_):
        break // ????
    }
  }
  
  func showWin(numGuesses: Int) {
    alertController.title = "Congratulations!"
    if numGuesses == 1 {
      alertController.message = "You guessed the word in \(numGuesses) try."
    } else {
      alertController.message = "You guessed the word in \(numGuesses) tries."
    }
    
    if !alertController.isBeingPresented {
      (navigationController?.topViewController ?? parent)?.present(alertController, animated: true)
    }
  }
  
  func showLose(clue: String) {
    alertController.title = "Aww 😢"
    alertController.message = "The actual word was \(clue). Good try!"
    
    if !alertController.isBeingPresented {
      (navigationController?.topViewController ?? parent)?.present(alertController, animated: true)
    }
  }
}
