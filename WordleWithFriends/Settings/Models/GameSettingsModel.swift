//
//  GameSettingsModel.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import Foundation

struct GameSettingsModel {
  static var clueLength = GameSettingIntRange(key: "clueLength",
                                              description: "Length of clue",
                                              minValue: 3,
                                              maxValue: 6)
  static var maxGuesses = GameSettingIntRange(key: "maxGuesses",
                                              description: "Max guesses",
                                              minValue: 1,
                                              maxValue: 20)
  
  static var allSettings: [GameSetting] {
    return [clueLength, maxGuesses]
  }
  
  static var numSettings: Int {
    allSettings.count
  }
}

// TODO Protocolize
struct GameSettingIntRange: GameSetting {
  
//  typealias T = Int
  
  var key: String
  var description: String
  var minValue: Int
  var maxValue: Int
  
//  init(key: String, description: String, minValue: Int, maxValue: Int) {
//    self.key = key
//    self.description = description
//    self.minValue = minValue
//    self.maxValue = maxValue
//  }
  
  func readValue() -> Any {
    UserDefaults.standard.integer(forKey: key)
  }
  
  func writeValue(_ value: Any) {
    UserDefaults.standard.set(value, forKey: key)
  }
}
