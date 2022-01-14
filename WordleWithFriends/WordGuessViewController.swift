//
//  WordGuessViewController.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

final class WordGuessViewController: UIViewController {
  var word: String = ""
  
  private lazy var guessTable: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 75 // TODO UNHARDCODE
    tableView.contentSize = CGSize(width: 75, height: 75)
    
    tableView.register(LetterTileTableViewCell.self, forCellReuseIdentifier: LetterTileTableViewCell.identifier)
    
    return tableView
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    view.addSubview(guessTable)
    guessTable.pin(to: view)
    
    title = "Guess the word"
  }
}

extension WordGuessViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5 // TODO UNHARDCODE
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: LetterTileTableViewCell.identifier) as? LetterTileTableViewCell else {
      return UITableViewCell()
    }
    
    // TODO CONFIGURE CELL
    
    return cell
  }
}
