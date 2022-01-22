//
//  LayoutUtility.swift
//  WordleWithFriends
//
//  Created by Personal on 1/15/22.
//

import UIKit


/// A collection of utilities to calculate sizes, positions, and general static layout
struct LayoutUtility {
  private static let screenWidth = UIScreen.main.bounds.size.width
  private static let screenHeight = UIScreen.main.bounds.size.height
  
  
//  private static let GRID_PADDING: Double = 8.0
  
  static func gridPadding(numberOfColumns: Int) -> Int {
    max(0, -2*numberOfColumns + 22)
  }
  
  /// Determines the max size of a square grid, given the variables
  /// - Parameters:
  ///   - numberOfColumns: Number of columns in the grid
  ///   - screenWidthPercentage: The amount of screen width that can be taken up by the grid
  /// - Returns: The length of a single cell in the grid. If the calculated length exceeds the max size, returns max size instead
  static func gridSize(numberOfColumns: Int, padding: Double, screenWidthPercentage: Double, maxSize: Double) -> Double {
    guard numberOfColumns >= 1, padding >= 0, screenWidthPercentage >= 0, screenWidthPercentage <= 100 else {
      return 0
    }
    
    let totalAllowedWidth = Double(screenWidth) * (screenWidthPercentage / 100.0)
    
    // subtract padding
    let totalAllowedLengthOfCells = totalAllowedWidth - Double(Double(numberOfColumns - 1) * padding)
    let calculatedLength = totalAllowedLengthOfCells / Double(numberOfColumns)
    return min(calculatedLength, maxSize)
  }
  
  /// Returns a size equivalent to a percentage of the screen width, capped at an absolute max width
  /// - Parameters:
  ///   - screenWidthPercentage: the target size relative to the screen width
  ///   - maxWidth: the max width
  /// - Returns: `screenWidthPercentage`% of the screen width, up to and including `maxWidth`
  static func size(screenWidthPercentage: Double, maxWidth: Int) -> Double {
    let sizeGivenPercentage = Double(screenWidth) * (screenWidthPercentage / 100.0)
    return min(sizeGivenPercentage, Double(maxWidth))
  }
}
