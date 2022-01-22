//
//  IndexPath+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/22/22.
//

import UIKit

extension IndexPath {
  static var zero: IndexPath = .init(row: 0, section: 0)
  
  static func Row(_ row: Int) -> IndexPath {
    return .init(row: row, section: 0)
  }
  
  static func Section(_ section: Int) -> IndexPath {
    return .init(row: 0, section: section)
  }
}
