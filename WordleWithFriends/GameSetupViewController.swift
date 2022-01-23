//
//  GameSetupViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class GameSetupViewController: UIViewController {
  
  private lazy var settingsButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "⚙", style: .plain, target: self, action: #selector(openSettings))
    button.accessibilityLabel = "Game settings"
    
    return button
  }()
  
  private lazy var instructionsTextLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    
    return label
  }()
  
  private lazy var startGameButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Start", for: .normal)
    button.setTitleColor(.systemGreen, for: .normal)
    button.addTarget(self, action: #selector(checkAndInitiateGame), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    button.setTitleColor(.systemGray, for: .disabled)
    button.isEnabled = false
    
    return button
  }()
  
  private lazy var randomWordButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Random word", for: .normal)
    button.setTitleColor(.systemOrange, for: .normal)
    button.addTarget(self, action: #selector(initiateGameWithRandomWord), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    
    return button
  }()
  
  private lazy var clueTextField: UITextField = {
    let textField = WordInputTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self
    textField.accessibilityIdentifier = "GameSetupViewController.clueTextField"
    
    return textField
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "Wordle with Friends"
    view.backgroundColor = .systemBackground
    
    navigationItem.leftBarButtonItem = settingsButton
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8.0
    
    updateScreen()
    stackView.addArrangedSubview(instructionsTextLabel)
    stackView.addArrangedSubview(clueTextField)
    stackView.addArrangedSubview(startGameButton)
    stackView.addArrangedSubview(randomWordButton)
    view.addSubview(stackView)
    
    let maxWidth = LayoutUtility.size(screenWidthPercentage: 85.0, maxWidth: 300)
    
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      clueTextField.widthAnchor.constraint(equalToConstant: CGFloat(maxWidth)),
    ])
    
    clueTextField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    startGameButton.isEnabled = false
    
    NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    
    clueTextField.resignFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startGameButton.isEnabled = false
    
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidUpdate), name: UITextField.textDidChangeNotification, object: nil)
    
    clueTextField.becomeFirstResponder()
  }
  
  @objc private func openSettings() {
    let vc = GameSettingsViewController()
    vc.delegate = self
    navigationController?.present(UINavigationController(rootViewController: vc), animated: true)
  }
  
  func updateScreen() {
    let clueLength = GameSettings.clueLength.readIntValue()
    instructionsTextLabel.text = "Welcome to Wordle with Friends.\nTo get started, enter a \(clueLength.spelledOut ?? "??")-letter English word below."
    
    clueTextField.accessibilityLabel = "Enter a \(clueLength)-letter word here."
  }
  
  @objc private func textFieldDidUpdate(_ notification: Notification) {
    guard let textField = notification.object as? UITextField else {
      return
    }
    
    if textField.text?.count == GameSettings.clueLength.readIntValue() {
      startGameButton.isEnabled = true
    } else {
      startGameButton.isEnabled = false
    }
  }
  
  private func isWordValid() -> WordValidity {
    guard let inputText = clueTextField.text else {
      return .missingWord
    }
    
    if inputText.count < GameSettings.clueLength.readIntValue() {
      return .insufficientLength
    } else if inputText.count > GameSettings.clueLength.readIntValue() {
      return .excessLength
    }
    
    if !inputText.isARealWord() {
      return .notDefined
    }
    
    return .valid
  }
  
  @objc private func checkAndInitiateGame() -> Bool {
    let wordValidity = isWordValid()
    let isValid = wordValidity == .valid
    if isValid {
      initiateGame(.human)
    } else {
      let ctrl = UIAlertController(title: "Error", message: wordValidity.rawValue, preferredStyle: .alert)
      ctrl.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
      self.present(ctrl, animated: true, completion: nil)
    }
    return isValid
  }
  
  @objc private func initiateGameWithRandomWord() {
    clueTextField.text = GameUtility.pickWord(length: GameSettings.clueLength.readIntValue())
    
    initiateGame(.computer)
  }

  private func initiateGame(_ clueSource: ClueSource) {
    // start game
    let wordGuessVC = WordGuessViewController(clue: clueTextField.text?.uppercased() ?? "", clueSource: clueSource)
    clueTextField.text = ""
    startGameButton.isEnabled = false
    
    clueTextField.resignFirstResponder()
    
    navigationController?.pushViewController(wordGuessVC, animated: true)
  }
}

extension GameSetupViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return checkAndInitiateGame()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard string.isLettersOnly() else {
      return false
    }
    
    guard (textField.text?.count ?? 0) + string.count <= GameSettings.clueLength.readIntValue() else {
      return false
    }
    
    return true
  }
}

extension GameSetupViewController: GameSettingsDelegate {
  func didDismissSettings() {
    updateScreen()
  }
}

enum WordValidity: String {
  case insufficientLength = "Your word is not long enough."
  case excessLength = "Your word is too long."
  case notDefined = "That's not a word in our dictionary."
  case missingWord = "Please input a word."
  case valid
}
