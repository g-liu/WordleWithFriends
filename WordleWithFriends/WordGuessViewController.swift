//
//  WordGuessViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessViewController: UIViewController {
  
  private var gameGuessesModel: GameGuessesModel = GameGuessesModel()
  
  private lazy var shareButton: UIBarButtonItem = {
    let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAction))
    button.isEnabled = false
    return button
  }()
  
  private lazy var guessTable: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.estimatedRowHeight = 50.0
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
  
  private var isBeingScrolled = false
  
  func setWord(_ word: String) {
    gameGuessesModel.clue = word
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    view.backgroundColor = .systemBackground
    
    addChild(gameMessagingVC)
    
    view.addSubview(guessTable)
    view.addSubview(guessInputTextField)
    guessTable.pin(to: view.safeAreaLayoutGuide, margins: .init(top: 12, left: 0, bottom: 0, right: 0))
    
    guessInputTextField.becomeFirstResponder()
    title = "Guess the word"
    
    navigationItem.rightBarButtonItem = shareButton
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    
    view.endEditing(true)
    guessInputTextField.resignFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    NotificationCenter.default.addObserver(self, selector: #selector(guessDidChange), name: UITextField.textDidChangeNotification, object: nil)
    
    guessInputTextField.becomeFirstResponder()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isBeingScrolled = false
  }
  
  @objc private func guessDidChange(_ notification: Notification) {
    guard let textField = notification.object as? UITextField else {
      isBeingScrolled = false
      return
    }
    let newGuess = textField.text ?? ""
    
    gameGuessesModel.updateGuess(newGuess)
    
    guessTable.reloadRows(at: [IndexPath(row: gameGuessesModel.numberOfGuesses, section: 0)], with: .none)
    
    if !isBeingScrolled {
      let rowInTable = IndexPath(row:  gameGuessesModel.numberOfGuesses, section: 0)
      guessTable.scrollToRow(at: rowInTable, at: .bottom, animated: true)
    }
  }
  
  private func submitGuess() {
    let gameState = gameGuessesModel.submitGuess()
    
    guessTable.reloadData()
    
    guessInputTextField.text = ""
    guessInputTextField.becomeFirstResponder()
    
    switch gameState {
      case .win:
        shareButton.isEnabled = true
        gameMessagingVC.showWin(numGuesses: gameGuessesModel.numberOfGuesses)
      case .lose:
        shareButton.isEnabled = true
        gameMessagingVC.showLose(clue: gameGuessesModel.clue)
      case .keepGuessing:
        shareButton.isEnabled = false
        break
    }
  }
  
  @objc private func adjustForKeyboard(notification: Notification) {
    guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    
    let keyboardScreenEndFrame = keyboardValue.cgRectValue
    let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
    
    if notification.name == UIResponder.keyboardWillHideNotification {
      guessTable.contentInset = .zero
    } else {
      guessTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
    }
    
    guessTable.scrollIndicatorInsets = guessTable.contentInset
  }
  
  @objc private func shareAction(_ sender: Any?) {
    gameGuessesModel.copyResult()
    guard let gameResult = UIPasteboard.general.string else {
      return
    }
    let ac = UIActivityViewController(activityItems: [gameResult], applicationActivities: nil)
    navigationController?.present(ac, animated: true)
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
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    isBeingScrolled = true
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    isBeingScrolled = false
  }
  
  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    isBeingScrolled = false
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate { isBeingScrolled = false }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    isBeingScrolled = false
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    isBeingScrolled = true
  }
  
  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    isBeingScrolled = false
  }
}

extension WordGuessViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // this is how we submit a guess
    guard let wordGuess = textField.text,
          wordGuess.count == GameSettings.clueLength.readIntValue(),
          GameSettings.allowNonDictionaryGuesses.readBoolValue() || wordGuess.isARealWord() else {
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
    
    return true
  }
}

extension WordGuessViewController: GameEndDelegate {
  func copyResult() {
    gameGuessesModel.copyResult()
  }
  
  func goToInitialScreen() {
    navigationController?.popToRootViewController(animated: true)
  }
  
}
