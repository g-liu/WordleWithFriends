//
//  GameSettingProtocol.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import Foundation

protocol GameSetting {
  var key: String { get set }
  var description: String { get set }
  
  func readValue() -> Any
  func writeValue(_ value: Any)
}
