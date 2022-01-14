//
//  ViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    let label = UILabel()
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Welcome to Wordle with Friends\nTo get started, enter a five-letter English word below:"
    label.textAlignment = .center
    
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.becomeFirstResponder()
    textField.layer.borderWidth = 1.0
    textField.layer.borderColor = UIColor.darkText.cgColor
    textField.autocapitalizationType = .allCharacters
    textField.autocorrectionType = .no
    textField.font = .monospacedSystemFont(ofSize: 38, weight: .bold)
    textField.textAlignment = .center
    textField.delegate = self
    
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Start", for: .normal)
    button.setTitleColor(.systemGreen, for: .normal)
    button.addTarget(self, action: #selector(initiateGame), for: .touchUpInside)
    button.titleLabel?.font = .boldSystemFont(ofSize: 16.0)
    button.setTitleColor(.systemGray, for: .disabled)
    button.isEnabled = false
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8.0
    
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(textField)
    stackView.addArrangedSubview(button)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      textField.widthAnchor.constraint(equalToConstant: 300) // TODO check this
    ])
  }

  @objc private func initiateGame(_ sender: Any) {
    guard let textField = sender as? UITextField else {
      return
    }
    
    guard let inputText = textField.text else {
      // todo alert
      return
    }
    
    if !UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: inputText) {
      // todo alert
      return
    }
    
    // start game
    
  }

}

extension ViewController: UITextFieldDelegate {
  
}
