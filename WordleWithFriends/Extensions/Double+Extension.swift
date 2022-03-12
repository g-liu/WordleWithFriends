//
//  Double+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/21/22.
//

import UIKit

extension Double {
  var asInt: Int { .init(self) }
  var asFloat: Float { .init(self) }
  var asCGFloat: CGFloat { .init(self) }
  
  static let e = 2.7182818284590452353602874713527
  
  static func +(left: Double, right: Int) -> Double {
    left + right.asDouble
  }
  
  static func +(left: Double, right: Float) -> Double {
    left + right.asDouble
  }
  
  static func +(left: Double, right: CGFloat) -> Double {
    left + right.asDouble
  }
  
  static func -(left: Double, right: Int) -> Double {
    left - right.asDouble
  }
  
  static func -(left: Double, right: Float) -> Double {
    left - right.asDouble
  }
  
  static func -(left: Double, right: CGFloat) -> Double {
    left - right.asDouble
  }
  
  static func *(left: Double, right: Int) -> Double {
    left * right.asDouble
  }
  
  static func *(left: Double, right: Float) -> Double {
    left * right.asDouble
  }
  
  static func *(left: Double, right: CGFloat) -> Double {
    left * right.asDouble
  }
  
  static func /(left: Double, right: Int) -> Double {
    left / right.asDouble
  }
  
  static func /(left: Double, right: Float) -> Double {
    left / right.asDouble
  }
  
  static func /(left: Double, right: CGFloat) -> Double {
    left / right.asDouble
  }
}

extension Double {
  static var dateComponentsFormatter = DateComponentsFormatter()
 
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    type(of: self).dateComponentsFormatter.allowedUnits = [.minute, .second]
    type(of: self).dateComponentsFormatter.unitsStyle = style
    return type(of: self).dateComponentsFormatter.string(from: self) ?? ""
  }
}
