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
  
  func readIntValue() -> Int
  func readStringValue() -> String?
  func writeValue(_ value: Any)
}

extension GameSetting {
  func readIntValue() -> Int {
    UserDefaults.standard.integer(forKey: key)
  }
  
  func readStringValue() -> String? {
    UserDefaults.standard.string(forKey: key)
  }
  
  func writeValue(_ value: Any) {
    UserDefaults.standard.set(value, forKey: key)
  }
}
