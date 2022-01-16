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
    
    tableView.register(WordGuessRow.self, forCellReuseIdentifier: WordGuessRow.identifier)
    
    return tableView
  }()
  
  private lazy var guessInputTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.isHidden = true
    textField.autocorrectionType = .no
    textField.keyboardType = .asciiCapable
    textField.autocapitalizationType = .allCharacters
    textField.delegate = self
    textField.layer.borderWidth = 1
    textField.layer.borderColor = UIColor.darkText.cgColor
    
    return textField
  }()
  
  private lazy var gameMessagingVC: GameMessagingViewController = {
    let vc = GameMessagingViewController()
    vc.delegate = self
    
    return vc
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
    
    addChild(gameMessagingVC)
    
    view.addSubview(guessTable)
    view.addSubview(guessInputTextField)
    guessTable.pin(to: view.safeAreaLayoutGuide, margins: .init(top: 12, left: 0, bottom: 0, right: 0))
    
    NSLayoutConstraint.activate([
      guessTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
      guessTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      guessTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      guessInputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      guessInputTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    guessInputTextField.becomeFirstResponder()
    title = "Guess the word"
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    guessInputTextField.resignFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    guessInputTextField.becomeFirstResponder()
  }
  
  @objc private func guessDidChange(_ notification: Notification) {
    guard let textField = notification.object as? UITextField else { return }
    let newGuess = textField.text ?? ""
    
    gameGuessesModel.updateGuess(newGuess)
    
    guessTable.reloadData()
  }
  
  private func submitGuess() {
    let gameState = gameGuessesModel.submitGuess()
    
    guessTable.reloadData()
    
    guessInputTextField.text = ""
    guessInputTextField.becomeFirstResponder()
    
    switch gameState {
      case .win:
        gameMessagingVC.showWin(numGuesses: gameGuessesModel.numberOfGuesses)
      case .lose:
        gameMessagingVC.showLose(actualWord: gameGuessesModel.actualWord)
      case .keepGuessing:
        break
    }
  }
}

extension WordGuessViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    GameSettings.maxGuesses.readIntValue()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: WordGuessRow.identifier) as? WordGuessRow else {
      return UITableViewCell()
    }
    
    if indexPath.row <= gameGuessesModel.numberOfGuesses,
       let wordGuessModel = gameGuessesModel.guess(at: indexPath.row) {
      cell.configure(with: wordGuessModel)
    } else {
      cell.configure()
    }
    
    return cell
  }
}

extension WordGuessViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // this is how we submit a guess
    guard let wordGuess = textField.text,
          wordGuess.count == GameSettings.clueLength.readIntValue(),
          wordGuess.isARealWord() else {
      gameGuessesModel.markInvalidGuess()
      guessTable.reloadData()
      return false
    }
    
    submitGuess()
    return false
  }
  
  override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    // Nope don't allow
    return false
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard !gameGuessesModel.isGameOver else {
      return false
    }
    
    // TODO UNDUPLICATE THIS!!!!!!
    guard string.isLettersOnly() else {
      return false
    }
    
    guard (textField.text?.count ?? 0) + string.count <= GameSettings.clueLength.readIntValue() else {
      return false
    }
    
    gameGuessesModel.clearInvalidGuess()
    guessTable.reloadData()
    
    return true
  }
}

extension WordGuessViewController: GameEndDelegate {
  func shareResult() {
    gameGuessesModel.copyResult()
  }
  
  func goToInitialScreen() {
    navigationController?.popToRootViewController(animated: true)
  }
  
}
