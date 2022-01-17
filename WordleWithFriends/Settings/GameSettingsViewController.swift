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
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseSettings))
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
    dismiss(animated: true) { [weak self] in self?.delegate?.didDismissSettings() }
  }
}

extension GameSettingsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    GameSettings.numSettings
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: GameSettingTableViewCell.identifier, for: indexPath) as? GameSettingTableViewCell else {
      return UITableViewCell()
    }
    
    // TODO: Account for other setting types
    if let setting = GameSettings.allSettings[indexPath.row] as? GameSettingIntRange {
      var config = UIListContentConfiguration.valueCell()
      config.text = setting.description
//      config.secondaryText = "\(setting.readIntValue())"
      let picker = NumberRangePickerView(frame: .init(x: 0, y: 0, width: 85, height: 66), minValue: setting.minValue, maxValue: setting.maxValue)
      picker.tag = indexPath.row
      picker.selectValue(setting.readIntValue())
      picker.didSelectNewValue = { newValue in
        setting.writeValue(newValue)
      }
      
      cell.contentConfiguration = config
      cell.accessoryView = picker
    } else if let setting = GameSettings.allSettings[indexPath.row] as? GameSettingBool {
      var config = UIListContentConfiguration.valueCell()
      config.text = setting.description
      
      let toggle = UISwitch()
      toggle.tag = indexPath.row
      toggle.setOn(setting.readBoolValue(), animated: true)
      toggle.addTarget(self, action: #selector(settingSwitchDidChange), for: .valueChanged)
      
      cell.contentConfiguration = config
      cell.accessoryView = toggle
    }
    
    return cell
  }
  
  @objc private func settingSwitchDidChange(_ toggle: UISwitch) {
    guard let setting = GameSettings.allSettings[toggle.tag] as? GameSettingBool else { return }
    setting.writeValue(toggle.isOn)
  }
}
