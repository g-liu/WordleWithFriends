//
//  GameSettingTableViewCell.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

final class GameSettingTableViewCell: UITableViewCell {
  static let identifier = "GameSettingTableViewCell"
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value2, reuseIdentifier: reuseIdentifier)
    setupCell()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupCell()
  }
  
  private func setupCell() {
    accessoryType = .disclosureIndicator
  }
  
  
}
