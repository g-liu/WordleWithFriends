//
//  GameSettingTableViewCell.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

class GameSettingTableViewCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupCell()
  }
  
  func setupCell() {
    accessoryType = .disclosureIndicator
  }
}

final class NumberRangeGameSettingCell: GameSettingTableViewCell {
  static let identifier = "NumberRangeGameSettingCell"
  
  func configure(with indexPath: IndexPath, setting: GameSettingIntRange) {
    var config = UIListContentConfiguration.valueCell()
    config.text = setting.description
    
    let picker = NumberRangePickerView(frame: .init(x: 0, y: 0, width: 85, height: 66), minValue: setting.minValue, maxValue: setting.maxValue)
    picker.tag = indexPath.row
    picker.selectValue(setting.readIntValue())
    picker.didSelectNewValue = { newValue in
      setting.writeValue(newValue)
    }
    
    contentConfiguration = config
    accessoryView = picker
  }
}

final class BoolGameSettingCell: GameSettingTableViewCell {
  static let identifier = "BoolGameSettingCell"
  
  func configure(with indexPath: IndexPath, setting: GameSettingBool) {
    var config = UIListContentConfiguration.valueCell()
    config.text = setting.description
    
    let toggle = UISwitch()
    toggle.tag = indexPath.row
    toggle.setOn(setting.readBoolValue(), animated: true)
    toggle.addTarget(self, action: #selector(settingSwitchDidChange), for: .valueChanged)
    
    contentConfiguration = config
    accessoryView = toggle
  }
  
  @objc private func settingSwitchDidChange(_ toggle: UISwitch) {
    guard let setting = GameSettings.allSettings[toggle.tag] as? GameSettingBool else { return }
    setting.writeValue(toggle.isOn)
  }
}
