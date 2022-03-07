//
//  GameSetupViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit
import AudioToolbox

final class GameSetupViewController: UIViewController {
  
  private var selectedGamemode: GameMode? {
    didSet {
      switch selectedGamemode {
        case .some(.human):
          // WHY THIS SO LAGGY???
          humanInstructionsTextLabel.isHidden = false
          clueTextField.isHidden = false
          clueTextField.becomeFirstResponder()
          startGameButton.isHidden = false
          versusHumanButton.isHidden = true
          versusComputerButton.isHidden = true
          infiniteModeButton.isHidden = true
          switchGamemodeButton.isHidden = false
        case .none,
            .some(.computer),
            .some(.infinite):
          humanInstructionsTextLabel.isHidden = true
          startGameButton.isHidden = true
          clueTextField.isHidden = true
          clueTextField.resignFirstResponder()
          versusHumanButton.isHidden = false
          versusComputerButton.isHidden = false
          infiniteModeButton.isHidden = false
          switchGamemodeButton.isHidden = true
      }
    }
  }
  
  private lazy var settingsButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "⚙", style: .plain, target: self, action: #selector(openSettings))
    button.accessibilityLabel = "Game settings"
    
    return button
  }()
  
  private lazy var welcomeTextLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.text = "Welcome to Wordle With Friends!"
    label.font = UIFont.boldSystemFont(ofSize: 24.0) // TODO: Dynamic font sizes
    
    return label
  }()
  
  private lazy var humanInstructionsTextLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.isHidden = true
    
    return label
  }()
  
  private lazy var versusHumanButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Play vs. human", for: .normal)
    button.addTarget(self, action: #selector(promptForClue), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    
    return button
  }()
  
  private lazy var versusComputerButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Play vs. computer", for: .normal)
    button.addTarget(self, action: #selector(initiateGameVersusComputer), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    
    return button
  }()
  
  private lazy var infiniteModeButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Infinite mode", for: .normal)
    button.addTarget(self, action: #selector(initiateGameOnInfiniteMode), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    
    return button
  }()
  
  private lazy var startGameButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Start", for: .normal)
    button.addTarget(self, action: #selector(checkAndInitiateGame), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    button.setTitleColor(.systemGray, for: .disabled)
    button.isEnabled = false
    button.isHidden = true
    
    return button
  }()
  
  private lazy var switchGamemodeButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Switch gamemode", for: .normal)
    button.addTarget(self, action: #selector(resetGamemode), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    button.setTitleColor(.systemGray, for: .disabled)
    button.isHidden = true
    
    return button
  }()
  
  private lazy var clueTextField: UITextField = {
    let textField = WordInputTextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self
    textField.accessibilityIdentifier = "GameSetupViewController.clueTextField"
    textField.isHidden = true
    
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
    stackView.addArrangedSubview(welcomeTextLabel)
    stackView.addArrangedSubview(humanInstructionsTextLabel)
    stackView.addArrangedSubview(clueTextField)
    stackView.addArrangedSubview(startGameButton)
    stackView.addArrangedSubview(switchGamemodeButton)
    stackView.addArrangedSubview(versusHumanButton)
    stackView.addArrangedSubview(versusComputerButton)
    stackView.addArrangedSubview(infiniteModeButton)
    view.addSubview(stackView)
    
    stackView.setCustomSpacing(32.0, after: welcomeTextLabel)
    stackView.setCustomSpacing(16.0, after: humanInstructionsTextLabel)
    
    let maxWidth = LayoutUtility.size(screenWidthPercentage: 85.0, maxWidth: 300)
    
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      clueTextField.widthAnchor.constraint(equalToConstant: CGFloat(maxWidth)),
    ])
    
    updateScreen()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    startGameButton.isEnabled = false
    
    NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    startGameButton.isEnabled = false
    
    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidUpdate), name: UITextField.textDidChangeNotification, object: nil)
  }
  
  @objc private func openSettings() {
    let vc = GameSettingsViewController()
    vc.delegate = self
    navigationController?.present(UINavigationController(rootViewController: vc), animated: true)
  }
  
  func updateScreen() {
    let clueLength = GameSettings.clueLength.readIntValue().spelledOut ?? " "
    humanInstructionsTextLabel.text = "Enter your \(GameSettings.clueLength.readIntValue().spelledOut ?? " ")-letter clue below:"

    clueTextField.accessibilityLabel = "Enter a \(clueLength)-letter word here."
  }
  
  @objc private func promptForClue() {
    // TODO: Ensure this stays uptodate
    selectedGamemode = .human
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
      initiateGame()
    } else {
      let ctrl = UIAlertController(title: "Error", message: wordValidity.rawValue, preferredStyle: .alert)
      ctrl.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
      AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
      self.present(ctrl, animated: true, completion: nil)
    }
    return isValid
  }
  
  @objc private func resetGamemode() {
    selectedGamemode = nil
  }
  
  @objc private func initiateGameVersusComputer() {
    selectedGamemode = .computer
    clueTextField.text = GameUtility.pickWord()
    
    initiateGame()
  }
  
  @objc private func initiateGameOnInfiniteMode() {
    selectedGamemode = .infinite
    clueTextField.text = GameUtility.pickWord()
    
    initiateGame()
  }

  private func initiateGame() {
    guard let gamemode = selectedGamemode else { return }
    // start game
    let clueGuessVC = ClueGuessViewController(clue: clueTextField.text?.uppercased() ?? "", gamemode: gamemode)
    clueTextField.text = ""
    startGameButton.isEnabled = false
    
    navigationController?.pushViewController(clueGuessVC, animated: true)
  }
}

extension GameSetupViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return checkAndInitiateGame()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard string.isLettersOnly(),
          (textField.text?.count ?? 0) + string.count <= GameSettings.clueLength.readIntValue() else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
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
