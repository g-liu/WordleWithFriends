//
//  Float+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/4/22.
//

import UIKit

extension Float {
  var asInt: Int { .init(self) }
  var asDouble: Double { .init(self) }
  var asCGFloat: CGFloat { .init(self) }
  
  static func +(left: Float, right: Int) -> Float {
    left + right.asFloat
  }
  
  static func +(left: Float, right: Double) -> Double {
    left.asDouble + right
  }
  
  static func +(left: Float, right: CGFloat) -> Float {
    left + right.asFloat
  }
  
  static func -(left: Float, right: Int) -> Float {
    left - right.asFloat
  }
  
  static func -(left: Float, right: Double) -> Double {
    left.asDouble - right
  }
  
  static func -(left: Float, right: CGFloat) -> Float {
    left - right.asFloat
  }
  
  static func *(left: Float, right: Int) -> Float {
    left * right.asFloat
  }
  
  static func *(left: Float, right: Double) -> Double {
    left.asDouble * right
  }
  
  static func *(left: Float, right: CGFloat) -> Float {
    left * right.asFloat
  }
  
  static func /(left: Float, right: Int) -> Float {
    left / right.asFloat
  }
  
  static func /(left: Float, right: Double) -> Double {
    left.asDouble / right
  }
  
  static func /(left: Float, right: CGFloat) -> Float {
    left / right.asFloat
  }
}
