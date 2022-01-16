//
//  GameSetupViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class GameSetupViewController: UIViewController {
  
  private lazy var settingsButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("⚙", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 24.0)
    button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    
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
  
  private lazy var initialWordTextField: UITextField = {
    let textField = WordInputTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self
    
    return textField
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setupVC()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupVC()
  }
  
  private func setupVC() {
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidUpdate), name: UITextField.textDidChangeNotification, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "Wordle with Friends"
    view.backgroundColor = .systemBackground
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8.0
    
    updateInstructionsText()
    stackView.addArrangedSubview(instructionsTextLabel)
    stackView.addArrangedSubview(initialWordTextField)
    stackView.addArrangedSubview(startGameButton)
    view.addSubview(stackView)
    view.addSubview(settingsButton)
    
    let maxWidth = LayoutUtility.size(screenWidthPercentage: 85.0, maxWidth: 300)
    
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      initialWordTextField.widthAnchor.constraint(equalToConstant: maxWidth),
      
      settingsButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 8.0),
      settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
    ])
    
    initialWordTextField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true) // TODO WHY THE FUCK IS THIS SHIT NOT WORKING
    startGameButton.isEnabled = false
    initialWordTextField.resignFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startGameButton.isEnabled = false // TODO THIS IS A HACK SEE ABOVE
    initialWordTextField.becomeFirstResponder()
  }
  
  @objc private func openSettings() {
    let vc = GameSettingsViewController()
    navigationController?.present(UINavigationController(rootViewController: vc), animated: true)
  }
  
  func updateInstructionsText() {
    instructionsTextLabel.text = "Welcome to Wordle with Friends.\nTo get started, enter a \(GameSettings.clueLength.readIntValue().spelledOut ?? "??")-letter English word below:"
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
    guard let inputText = initialWordTextField.text else {
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
      initiateGame()
    } else {
      let ctrl = UIAlertController(title: "Error", message: wordValidity.rawValue, preferredStyle: .alert)
      ctrl.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
      self.present(ctrl, animated: true, completion: nil)
    }
    return isValid
  }

  private func initiateGame() {
    // start game
    let wordGuessVC = WordGuessViewController()
    wordGuessVC.setWord(initialWordTextField.text?.uppercased() ?? "")
    initialWordTextField.text = ""
    startGameButton.isEnabled = false
    
    initialWordTextField.resignFirstResponder()
    
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

enum WordValidity: String {
  case insufficientLength = "Your word is not long enough."
  case excessLength = "Your word is too long."
  case notDefined = "That's not a word in our dictionary."
  case missingWord = "Please input a word."
  case valid
}
