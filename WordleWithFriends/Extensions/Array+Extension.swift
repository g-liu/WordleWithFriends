//
//  Array+Extension.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/6/22.
//

extension Array {
  mutating func prepend(_ newElement: Element) {
    insert(newElement, at: 0)
  }
}
