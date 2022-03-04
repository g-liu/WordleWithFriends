//
//  Int+Extension.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit

extension Int {
  var asDouble: Double { .init(self) }
  var asFloat: Float { .init(self) }
  var asCGFloat: CGFloat { .init(self) }
  
  static var formatter: NumberFormatter = {
    let fmt = NumberFormatter()
    fmt.numberStyle = .spellOut
    return fmt
  }()
  
  var spelledOut: String? {
    type(of: self).formatter.string(from: self as NSNumber)
  }
  
  // MARK: - Addition
  
  static func +(left: Int, right: Double) -> Double {
    left.asDouble + right
  }
  
  static func +(left: Int, right: Float) -> Float {
    left.asFloat + right
  }
  
  static func +(left: Int, right: CGFloat) -> CGFloat {
    left.asCGFloat + right
  }
  
  // MARK: - Subtraction
  
  static func -(left: Int, right: Double) -> Double {
    left.asDouble - right
  }
  
  static func -(left: Int, right: Float) -> Float {
    left.asFloat - right
  }
  
  static func -(left: Int, right: CGFloat) -> CGFloat {
    left.asCGFloat - right
  }
  
  // MARK: - Multiplication
  
  static func *(left: Int, right: Double) -> Double {
    left.asDouble * right
  }
  
  static func *(left: Int, right: Float) -> Float {
    left.asFloat * right
  }
  
  static func *(left: Int, right: CGFloat) -> CGFloat {
    left.asCGFloat * right
  }
  
  // MARK: - Division
  
  static func /(left: Int, right: Double) -> Double {
    left.asDouble / right
  }
  
  static func /(left: Int, right: Float) -> Float {
    left.asFloat / right
  }
  
  static func /(left: Int, right: CGFloat) -> CGFloat {
    left.asCGFloat / right
  }
}
