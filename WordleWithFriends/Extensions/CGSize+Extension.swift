//
//  CGSize+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/18/22.
//

import UIKit

extension CGSize {
  static func -(left: CGSize, right: UIEdgeInsets) -> CGSize {
    let newWidth = left.width - right.left - right.right
    let newHeight = left.height - right.top - right.bottom
    
    return .init(width: newWidth, height: newHeight)
  }
}
