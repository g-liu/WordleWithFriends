//
//  ViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class ViewController: UIViewController {
  
  private static let MAX_WORD_LENGTH = 5
  
  private lazy var startGameButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Start", for: .normal)
    button.setTitleColor(.systemGreen, for: .normal)
    button.addTarget(self, action: #selector(initiateGame), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    button.setTitleColor(.systemGray, for: .disabled)
    button.isEnabled = false
    
    return button
  }()
  
  private lazy var initialWordTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.darkText.cgColor
    textField.autocapitalizationType = .allCharacters
    textField.autocorrectionType = .no
    textField.font = .monospacedSystemFont(ofSize: 38, weight: .bold)
    textField.keyboardType = .asciiCapable
    textField.textAlignment = .center
    textField.delegate = self
    // TODO: Disable selection on textField
    
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
    
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Welcome to Wordle with Friends\nTo get started, enter a five-letter English word below:"
    label.textAlignment = .center
    
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8.0
    
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(initialWordTextField)
    stackView.addArrangedSubview(startGameButton)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      initialWordTextField.widthAnchor.constraint(equalToConstant: 300) // TODO check this
    ])
  }
  
  @objc private func textFieldDidUpdate(_ notification: Notification) {
    guard let textField = notification.object as? UITextField else {
      return
    }
    
    if textField.text?.count == 5 {
      startGameButton.isEnabled = true
    } else {
      startGameButton.isEnabled = false
    }
  }

  @objc private func initiateGame(_ sender: Any) {
    guard let inputText = initialWordTextField.text else {
      // todo alert
      return
    }
    
    if !inputText.isARealWord() {
      // todo better alert
      let ctrl = UIAlertController(title: "Error", message: "That word doesn't exist", preferredStyle: .alert)
      ctrl.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
      self.present(ctrl, animated: true, completion: nil)
      return
    }
    
    // start game
    let wordGuessVC = WordGuessViewController()
    wordGuessVC.word = inputText
    initialWordTextField.text = ""
    
    navigationController?.pushViewController(wordGuessVC, animated: true)
    
  }

}

extension ViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard string.isLettersOnly() else {
      return false
    }
    
    guard (textField.text?.count ?? 0) + string.count <= type(of: self).MAX_WORD_LENGTH else {
      return false
    }
    
    return true
  }
}
