//
//  GameUtility.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/22/22.
//

import Foundation

struct GameUtility {
  static func pickWord(length: Int = GameSettings.clueLength.readIntValue()) -> String {
    guard let path = Bundle.main.path(forResource: "words_\(GameSettings.clueLength.readIntValue())letters", ofType: "txt"),
          let data = try? String(contentsOfFile: path) else { return "" }
    
    let allWords = data.components(separatedBy: "\n")
    let word = allWords[Int.random(in: 0..<allWords.count)]
    
    return word.uppercased()
  }
}
