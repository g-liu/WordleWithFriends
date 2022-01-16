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
    table.register(UITableViewCell.self, forCellReuseIdentifier: "Temp") // TODO Remove
    table.rowHeight = UITableView.automaticDimension
    table.allowsSelection = false
    
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
    
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Temp", for: indexPath)
    let setting = GameSettingsModel.allSettings[indexPath.row]
    
    var config = UIListContentConfiguration.sidebarCell()
    config.text = setting.description
//    config.secondaryText = "yuhhhh"
    
    // todo: adapt to setting type
    let pickerView = NumberRangePickerView(minValue: setting.minValue, maxValue: setting.maxValue)
    
    cell.contentConfiguration = config
    cell.accessoryView = pickerView // TODO this looks horrendous
    return cell
  }
  
  
}
