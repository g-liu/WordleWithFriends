//
//  GameSettingProtocol.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import Foundation

protocol GameSetting {
  associatedtype T
  
  var key: String { get set }
  var description: String { get set }
  
  func readValue() -> T
  func writeValue(_ value: T)
}
