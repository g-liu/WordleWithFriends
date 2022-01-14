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
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.rowHeight = UITableView.automaticDimension
    
    tableView.register(WordGuessTableViewCell.self, forCellReuseIdentifier: WordGuessTableViewCell.identifier)
    
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
    guessTable.pin(to: view.safeAreaLayoutGuide, margins: .init(top: 12, left: 0, bottom: 0, right: 0))
    
    title = "Guess the word"
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
    
    return cell
  }
}
