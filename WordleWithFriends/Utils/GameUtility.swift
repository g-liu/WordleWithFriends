//
//  GameUtility.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/22/22.
//

import Foundation

struct GameUtility {
  static func pickWord(length: Int = GameSettings.clueLength.readIntValue(),
                       checkIOSDictionary: Bool = !GameSettings.allowNonDictionaryGuesses.readBoolValue()) -> String {
    guard let path = Bundle.main.path(forResource: "words_\(GameSettings.clueLength.readIntValue())letters", ofType: "txt"),
          let data = try? String(contentsOfFile: path) else { return "" }
    
    // TODO: Very inefficient to load entire file, can we read line by line next time?
    let allWords = data.components(separatedBy: "\n")
    var word: String
    
    repeat {
      word = allWords[Int.random(in: 0..<allWords.count)]
    } while checkIOSDictionary ? !word.isARealWord() : false
    
    return word.uppercased()
  }
}
