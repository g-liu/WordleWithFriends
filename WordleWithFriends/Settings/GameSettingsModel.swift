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
  
  static var allSettings: [GameSettingIntRange] {
    return [clueLength, maxGuesses]
  }
  
  static var numSettings: Int {
    allSettings.count
  }
  
//  init() {
//    readSettings()
//  }
  
//  mutating private func readSettings() {
//    clueLength.readSetting()
//    maxGuesses.readSetting()
//  }
}

// TODO Protocolize
struct GameSettingIntRange {
  var key: String
  var description: String
  var minValue: Int
  var maxValue: Int
  
  func readValue() -> Int  {
    UserDefaults.standard.integer(forKey: key)
  }
  
  func setValue(_ value: Int) {
    UserDefaults.standard.set(value, forKey: key)
  }
  
//  init(key: String) {
//    self.key = key
//  }
//
//  @discardableResult
//  mutating func readSetting() -> T? {
//    if let readValue = UserDefaults.standard.bool(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.integer(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.float(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.double(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.string(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.url(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.stringArray(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.data(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.dictionary(forKey: key) as? T {
//      value = readValue
//    } else if let readValue = UserDefaults.standard.object(forKey: key) as? T {
//      value = readValue
//    }
//
//    return value
//  }
//
//  mutating func writeSetting(newValue: T) {
//    value = newValue
//    UserDefaults.standard.set(value, forKey: key)
//  }
}
