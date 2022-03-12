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
  
  mutating func append(_ newElements: Element...) {
    append(contentsOf: newElements)
  }
}

extension Sequence {
  func splitIncludeDelimiter(whereSeparator shouldDelimit: (Element) throws -> Bool) rethrows -> [[Element]] {
    try self.reduce([[]]) { group, next in
      var group = group
      if try shouldDelimit(next) {
        group[group.count - 1].append(next)
        group.append([])
      } else {
        group[group.count - 1].append(next)
      }
      return group
    }
  }
}
