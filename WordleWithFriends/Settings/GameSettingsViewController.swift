//
//  GameSettingsViewController.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

final class GameSettingsViewController: UIViewController {
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
    
    let moab = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseSettings))
    
    title = "Settings"
    navigationItem.title = "Settings"
    navigationItem.rightBarButtonItem = moab
    view.backgroundColor = .systemBackground
    
    let table = UITableView(frame: .zero, style: .insetGrouped)
    table.translatesAutoresizingMaskIntoConstraints = false
    table.delegate = self
    table.dataSource = self
    table.register(GameSettingTableViewCell.self, forCellReuseIdentifier: GameSettingTableViewCell.identifier)
    table.rowHeight = UITableView.automaticDimension
    
    view.addSubview(table)
    table.pin(to: view.safeAreaLayoutGuide)
  }
  
  @objc private func didTapCloseSettings() {
    dismiss(animated: true, completion: nil)
  }
}

extension GameSettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    GameSettingsModel.numSettings
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: GameSettingTableViewCell.identifier, for: indexPath) as? GameSettingTableViewCell else {
      return UITableViewCell()
    }
    
    let setting = GameSettingsModel.allSettings[indexPath.row]
    
    var config = UIListContentConfiguration.valueCell()
    config.text = setting.description
    config.secondaryText = "\(setting.readIntValue())"
    
    cell.contentConfiguration = config
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // bring up picka
    
  }
  
  
}
