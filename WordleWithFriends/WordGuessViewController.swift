//
//  WordGuessViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessViewController: UIViewController {
  
  // Extremely hacky workaround of table jumpiness when reloading...
  // https://stackoverflow.com/questions/28244475/reloaddata-of-uitableview-with-dynamic-cell-heights-causes-jumpy-scrolling
  private var cellHeightCache: [IndexPath: CGFloat] = [:]

  private var gameGuessesModel: GameGuessesModel
  
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
  
  private var gameMessagingVC: GameMessagingViewController
  
  private var isBeingScrolled = false
  
  init(clue: String, clueSource: ClueSource) {
    gameGuessesModel = GameGuessesModel(clue: clue)
    gameMessagingVC = GameMessagingViewController(clueSource: clueSource)
    super.init(nibName: nil, bundle: nil)
    gameMessagingVC.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      let currentRow = IndexPath.Row(self.gameGuessesModel.numberOfGuesses)
      self.guessTable.reloadRows(at: [currentRow], with: .none)
      
      if !self.isBeingScrolled {
        self.guessTable.scrollToRow(at: currentRow, at: .bottom, animated: true)
      }
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
        guessTable.scrollToRow(at: IndexPath.Row(gameGuessesModel.numberOfGuesses), at: .bottom, animated: true)
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
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cellHeightCache[indexPath] = cell.frame.size.height
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if let height = self.cellHeightCache[indexPath] {
      return height
    }
    return 50.0
  }
}

extension WordGuessViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // this is how we submit a guess
    guard let wordGuess = textField.text,
          wordGuess.count == GameSettings.clueLength.readIntValue(),
          GameSettings.allowNonDictionaryGuesses.readBoolValue() || wordGuess.isARealWord() else {
      gameGuessesModel.markInvalidGuess()
      let currentIndexPath = IndexPath.Row(gameGuessesModel.numberOfGuesses)
      guessTable.reloadRows(at: [currentIndexPath], with: .none)
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
  func shareResult() {
    shareAction(nil)
  }
  
  func goToInitialScreen() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  func restartWithNewClue() {
    let newClue = GameUtility.pickWord(length: GameSettings.clueLength.readIntValue())
    gameGuessesModel = GameGuessesModel(clue: newClue)
    
    DispatchQueue.main.async { [weak self] in
      self?.guessTable.reloadData()
      // TODO: In the future might have to reset `cellHeightCache`
      self?.guessTable.scrollToRow(at: .zero, at: .bottom, animated: true)
    }
  }
}
