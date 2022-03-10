//
//  ClueGuessViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit
import AudioToolbox

final class ClueGuessViewController: UIViewController {
  
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
  
  private lazy var wordleKeyboard: WordleKeyboardInputView = {
    let inputView = WordleKeyboardInputView(gamemode: gameGuessesModel.gamemode)
    inputView.delegate = self
    return inputView
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
    textField.inputView = wordleKeyboard
    
    return textField
  }()
  
  private lazy var loadingView: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .large)
    view.translatesAutoresizingMaskIntoConstraints = false
    
    view.startAnimating()
    view.isHidden = true
    
    return view
  }()
  
  private var gameMessagingVC: GameMessagingViewController
  
  private var isBeingScrolled = false
  
  init(clue: String, gamemode: GameMode) {
    gameGuessesModel = GameGuessesModel(clue: clue, gamemode: gamemode)
    gameMessagingVC = GameMessagingViewController(gamemode: gamemode)
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
    view.addSubview(loadingView)
    guessTable.pin(to: view.safeAreaLayoutGuide, margins: .init(top: 12, left: 0, bottom: 0, right: 0))
    loadingView.pin(to: view.safeAreaLayoutGuide)
    
    guessInputTextField.becomeFirstResponder()
    title = "Guess the clue"
    
    if gameGuessesModel.gamemode != .infinite {
      navigationItem.rightBarButtonItem = shareButton
    }
    
    navigationItem.setHidesBackButton(true, animated: true)
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
    
    if let mostRecentGuess = gameGuessesModel.mostRecentGuess {
      wordleKeyboard.updateState(with: mostRecentGuess)
    }
    
    switch gameState {
      case .win:
        guessTable.reloadData()
        wordleKeyboard.gameDidEnd()
        if gameGuessesModel.gamemode == .infinite {
          presentToast("Good job! \(gameGuessesModel.numberOfGuesses) guess(es)")
          DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.restartWithNewClue()
          }
        } else {
          shareButton.isEnabled = true
          gameMessagingVC.showWin(numGuesses: gameGuessesModel.numberOfGuesses)
        }
        guessInputTextField.text = ""
        
      case .lose:
        guessTable.reloadData()
        guessInputTextField.text = ""
        
        forceLoss()
      case .keepGuessing:
        guessTable.reloadData()
        guessInputTextField.text = ""
        
        guessTable.scrollToRow(at: IndexPath.Row(gameGuessesModel.numberOfGuesses), at: .bottom, animated: true)
      case .invalidGuess(let missingCharacters):
        indicateInvalidGuess(reason: "Guess must contain letters: \(missingCharacters.asCommaSeparatedList)")
      case .notAWord:
        indicateInvalidGuess(reason: "That's not a word in our dictionary.")
      case .invalidLength:
        indicateInvalidGuess(reason: "Guess must be exactly \(GameSettings.clueLength.readIntValue()) letters")
    }
  }
  
  private func indicateInvalidGuess(reason: String) {
    gameGuessesModel.markInvalidGuess()
    let currentIndexPath = IndexPath.Row(gameGuessesModel.numberOfGuesses)
    guessTable.reloadRows(at: [currentIndexPath], with: .none)
    
    dismissAllToasts()
    presentToast(reason)
          
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

    return
  }
  
  private func forceLoss() {
    gameGuessesModel.forceGameOver()
    wordleKeyboard.gameDidEnd()
    if gameGuessesModel.gamemode == .infinite {
      presentToast(gameGuessesModel.clue)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
        self?.restartWithNewClue()
      }
    } else {
      shareButton.isEnabled = true
      gameMessagingVC.showLose(clue: gameGuessesModel.clue)
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
    loadingView.isHidden = false
    let ac = UIActivityViewController(activityItems: [gameResult], applicationActivities: nil)
    navigationController?.present(ac, animated: true) { [weak self] in
      self?.loadingView.isHidden = true
    }
  }
}

extension ClueGuessViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return GameSettings.maxGuesses.readIntValue()
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

extension ClueGuessViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // TODO: Coalesce logic with didTapSubmit
    guard !gameGuessesModel.isGameOver else { return false }
    
    submitGuess()
    return false
  }
  
  override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    // Nope don't allow
    return false
  }
  
  // Note: We still need this function as users can use bluetooth keyboard etc. to bypass the onscreen input
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard !gameGuessesModel.isGameOver else { return false }
    guard string.isLettersOnly(),
          (textField.text?.count ?? 0) + string.count <= GameSettings.clueLength.readIntValue() else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return false
          }
    
    gameGuessesModel.clearInvalidGuess()
    
    return true
  }
}

extension ClueGuessViewController: GameEndDelegate {
  func shareResult() {
    shareAction(nil)
  }
  
  func goToInitialScreen() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  func restartWithNewClue() {
    let newClue = GameUtility.pickWord()
    gameGuessesModel = GameGuessesModel(clue: newClue, gamemode: gameGuessesModel.gamemode)
    guessInputTextField.text = ""
    
    wordleKeyboard.resetKeyboard()
    
    DispatchQueue.main.async { [weak self] in
      self?.guessTable.reloadData()
      // TODO: In the future might have to reset `cellHeightCache`
      self?.guessTable.scrollToRow(at: .zero, at: .bottom, animated: true)
    }
  }
}

extension ClueGuessViewController: KeyTapDelegate {
  func didTapKey(_ char: Character) {
    guard !gameGuessesModel.isGameOver else { return }
    guard guessInputTextField.text?.isLettersOnly() ?? false,
          (guessInputTextField.text?.count ?? 0) < GameSettings.clueLength.readIntValue() else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return
          }
    
    guessInputTextField.insertText("\(char)")
  }
  
  func didTapSubmit() {
    guard !gameGuessesModel.isGameOver else { return }
    submitGuess()
  }
  
  func didTapDelete() {
    guessInputTextField.deleteBackward()
  }
  
  func didForfeit() {
    forceLoss()
  }
  
  func didTapMainMenu() {
    let alertController = DismissableAlertController(title: nil, message: "Return to main menu?", preferredStyle: .alert)
    alertController.addAction(.init(title: "Yes", style: .default, handler: { [weak self] _ in
      self?.navigationController?.popViewController(animated: true)
    }))
    alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
    
    present(alertController, animated: true)
  }
}
