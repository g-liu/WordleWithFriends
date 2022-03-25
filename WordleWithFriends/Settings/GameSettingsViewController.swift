//
//  GameSettingsViewController.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

protocol GameSettingsDelegate {
  func didDismissSettings()
}

final class GameSettingsViewController: UIViewController {
  var delegate: GameSettingsDelegate?
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setupVC()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupVC()
  }
  
  private func setupVC() {
//    modalPresentationStyle = .pageSheet
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Settings"
    navigationItem.title = "Settings"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    view.backgroundColor = .systemBackground
    
    let table = UITableView(frame: .zero, style: .insetGrouped).autolayoutEnabled
    table.delegate = self
    table.dataSource = self
    table.register(NumberRangeGameSettingCell.self, forCellReuseIdentifier: NumberRangeGameSettingCell.identifier)
    table.register(BoolGameSettingCell.self, forCellReuseIdentifier: BoolGameSettingCell.identifier)
    table.rowHeight = UITableView.automaticDimension
    
    view.addSubview(table)
    table.pin(to: view.safeAreaLayoutGuide)
  }
  
  @objc private func didTapClose() {
    dismiss(animated: true) { [weak self] in self?.delegate?.didDismissSettings() }
  }
}

extension GameSettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    GameSettings.numSettings
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell
    if let setting = GameSettings.allSettings[indexPath.row] as? GameSettingIntRange {
      guard let numberRangeCell = tableView.dequeueReusableCell(withIdentifier: NumberRangeGameSettingCell.identifier, for: indexPath) as? NumberRangeGameSettingCell else {
        return UITableViewCell()
      }
      numberRangeCell.configure(with: indexPath, setting: setting)
      cell = numberRangeCell
    } else if let setting = GameSettings.allSettings[indexPath.row] as? GameSettingBool {
      guard let boolCell = tableView.dequeueReusableCell(withIdentifier: BoolGameSettingCell.identifier, for: indexPath) as? BoolGameSettingCell else {
        return UITableViewCell()
      }
      boolCell.configure(with: indexPath, setting: setting)
      cell = boolCell
    } else {
      cell = UITableViewCell()
    }
    
    return cell
  }
}
