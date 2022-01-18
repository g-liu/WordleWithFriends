//
//  CGPoint+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/18/22.
//

import UIKit

extension CGPoint {
  static func +(left: CGPoint, right: CGPoint) -> CGPoint {
    let newX = left.x + right.x
    let newY = left.y + right.y
    
    return .init(x: newX, y: newY)
  }
}
 
