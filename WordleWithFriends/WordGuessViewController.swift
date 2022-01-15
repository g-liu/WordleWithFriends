//
//  WordGuessViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessViewController: UIViewController {
  
  private var gameGuessesModel: GameGuessesModel = GameGuessesModel()
  
  private lazy var guessTable: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.register(WordGuessTableViewCell.self, forCellReuseIdentifier: WordGuessTableViewCell.identifier)
    
    return tableView
  }()
  
  private lazy var guessInputTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isHidden = true // todo hide
    textField.autocorrectionType = .no
    textField.keyboardType = .asciiCapable
    textField.autocapitalizationType = .allCharacters
    textField.delegate = self
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.darkText.cgColor
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
  
  func setWord(_ word: String) {
    gameGuessesModel.actualWord = word
  }
  
  private func setupVC() {
    NotificationCenter.default.addObserver(self, selector: #selector(guessDidChange), name: UITextField.textDidChangeNotification, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(guessTable)
    view.addSubview(guessInputTextField)
    guessTable.pin(to: view.safeAreaLayoutGuide, margins: .init(top: 12, left: 0, bottom: 0, right: 0))
    
    NSLayoutConstraint.activate([
      guessInputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      guessInputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    guessInputTextField.becomeFirstResponder()
    title = "Guess the word"
  }
  
  @objc private func guessDidChange(_ notification: Notification) {
    guard let textField = notification.object as? UITextField else { return }
    let newGuess = textField.text ?? ""
    
    gameGuessesModel.updateGuess(newGuess)
    
    guessTable.reloadData()
  }
  
  private func submitGuess() {
    gameGuessesModel.submitGuess()
    
    guessTable.reloadData()
    
    guessInputTextField.text = ""
    guessInputTextField.becomeFirstResponder()
  }
}

extension WordGuessViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    6 // TODO UNHARDCODE
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WordGuessTableViewCell.identifier) as? WordGuessTableViewCell else {
      return UITableViewCell()
    }
    
    // TODO CONFIGURE CELL
    if indexPath.row < gameGuessesModel.numberOfGuesses,
       let wordGuessModel = gameGuessesModel.guess(at: indexPath.row) {
      cell.configure(with: wordGuessModel)
    }
    
    return cell
  }
}

extension WordGuessViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // this is how we submit a guess
    guard let wordGuess = textField.text else { return false }
    
    guard wordGuess.count == 5 else { return false }
    
    guard wordGuess.isARealWord() else { return false }
    
    submitGuess() // TODO: Is side-effecting here OK?
    return false
  }
  
  override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    // Nope don't allow
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // TODO UNDUPLICATE THIS!!!!!!
    guard string.isLettersOnly() else {
      return false
    }
    
    guard (textField.text?.count ?? 0) + string.count <= ViewController.MAX_WORD_LENGTH else {
      return false
    }
    
    return true
  }
}
