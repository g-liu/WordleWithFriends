//
//  CGFloat+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/4/22.
//

import UIKit

extension CGFloat {
  var asInt: Int { .init(self) }
  var asDouble: Double { .init(self) }
  var asFloat: Float { .init(self) }
  
  static func +(left: CGFloat, right: Int) -> CGFloat {
    left + right.asCGFloat
  }
  
  static func +(left: CGFloat, right: Double) -> Double {
    left.asDouble + right
  }
  
  static func +(left: CGFloat, right: Float) -> Float {
    left.asFloat + right
  }
  
  static func -(left: CGFloat, right: Int) -> CGFloat {
    left - right.asCGFloat
  }
  
  static func -(left: CGFloat, right: Double) -> Double {
    left.asDouble - right
  }
  
  static func -(left: CGFloat, right: Float) -> Float {
    left.asFloat - right
  }
  
  static func *(left: CGFloat, right: Int) -> CGFloat {
    left * right.asCGFloat
  }
  
  static func *(left: CGFloat, right: Double) -> Double {
    left.asDouble * right
  }
  
  static func *(left: CGFloat, right: Float) -> Float {
    left.asFloat * right
  }
  
  static func /(left: CGFloat, right: Int) -> CGFloat {
    left / right.asCGFloat
  }
  
  static func /(left: CGFloat, right: Double) -> Double {
    left.asDouble / right
  }
  
  static func /(left: CGFloat, right: Float) -> Float {
    left.asFloat / right
  }
}
