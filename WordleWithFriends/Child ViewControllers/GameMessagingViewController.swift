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
  
  private lazy var shareGuessButton: UIAlertAction = {
    .init(title: "Share", style: .default) { [weak self] _ in
      self?.delegate?.shareResult()
    }
  }()
  
  private lazy var mainMenuButton: UIAlertAction = {
    .init(title: "", style: .default) { [weak self] _ in
      self?.delegate?.goToInitialScreen()
    }
  }()
  
  private lazy var newClueButton: UIAlertAction = {
    .init(title: "New clue", style: .default) { [weak self] _ in
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
    switch gamemode {
      case .human:
        alertController.addAction(shareGuessButton)
        break
      case .computer:
        alertController.addAction(shareGuessButton)
        alertController.addAction(newClueButton)
      case .infinite:
        alertController.addAction(shareGuessButton)
        break // Infinite game mode never touches this VC
      case .timeTrial(_):
        alertController.addAction(newClueButton)
        newClueButton.setValue("Play again", forKeyPath: "title")
        break
    }
    
    alertController.addAction(mainMenuButton)
    mainMenuButton.setValue("Main menu", forKeyPath: "title")
  }
  
  func showWin(numGuesses: Int) {
    alertController.title = "Congratulations!"
    // TODO: Pluralization
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
  
  func showEndOfTimeTrial(statistics: GameStatistics) {
    alertController.title = "Time's up!"
    // TODO: PLURALIZE EVERYTHING
    var message = """
You got \(statistics.numCompletedClues) clue(s) right:
\(statistics.completedClues.joined(separator: ", "))

You skipped \(statistics.numSkippedClues) clue(s):
\(statistics.skippedClues.joined(separator: ", "))

Overall, you made \(statistics.totalGuesses) guess(es).

Average time per clue: \(String(format: "%.2f", statistics.averageTimePerClue)) seconds
Average guesses per clue: \(String(format: "%.1f", statistics.averageGuessesPerClue))

"""
    
    if statistics.numCompletedClues > 0 {
      let fmt = DateComponentsFormatter()
      fmt.allowedUnits = [.minute, .second]
      fmt.allowsFractionalUnits = true
      fmt.unitsStyle = .full
      message += """
      
Best clue: \(statistics.lowestGuessCountForCompletedClue.clue), \(statistics.lowestGuessCountForCompletedClue.guessCount) guess(es)
Worst clue: \(statistics.highestGuessCountForCompletedClue.clue), \(statistics.highestGuessCountForCompletedClue.guessCount) guess(es)

Fastest guessed: \(statistics.fastestGuessForCompletedClue.clue), \(fmt.string(from: statistics.fastestGuessForCompletedClue.timeElapsed) ?? "")
Slowest guessed: \(statistics.slowestGuessForCompletedClue.clue), \(fmt.string(from: statistics.slowestGuessForCompletedClue.timeElapsed) ?? "")
"""
    }
    
    if statistics.isNewPersonalBest {
      message += """

🎉 You set a personal best, beating your old score of \(statistics.personalBest) 🎉
"""
    }
    
    alertController.message = message
    
    if !alertController.isBeingPresented {
      (navigationController?.topViewController ?? parent)?.present(alertController, animated: true)
    }
  }
}
