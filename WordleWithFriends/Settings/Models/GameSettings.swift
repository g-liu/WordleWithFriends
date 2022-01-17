//
//  GameSettings.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import Foundation

struct GameSettings {
  static var clueLength = GameSettingIntRange(key: "clueLength",
                                              description: "Length of clue",
                                              minValue: 3,
                                              maxValue: 8)
  static var maxGuesses = GameSettingIntRange(key: "maxGuesses",
                                              description: "Max guesses",
                                              minValue: 1,
                                              maxValue: 20)
  static var allowNonDictionaryGuesses = GameSettingBool(key: "allowNonDictionaryGuesses",
                                                         description: "Allow non-word guesses")
  
  static var allSettings: [GameSetting] {
    return [clueLength, maxGuesses, allowNonDictionaryGuesses]
  }
  
  static var numSettings: Int {
    allSettings.count
  }
}

struct GameSettingBool: GameSetting {
  var key: String
  var description: String
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
  
  
}
