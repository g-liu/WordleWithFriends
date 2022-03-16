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
  
  var rest: Array {
    Array(dropFirst())
  }
  
  func splitIncludeDelimiter(whereSeparator shouldDelimit: (Element) throws -> Bool) rethrows -> [[Element]] {
    try enumerated().reduce([[]]) { group, next in
      var group = group
      let nextElement = next.element; let nextOffset = next.offset
      if try shouldDelimit(nextElement) {
        group[group.count - 1].append(nextElement)
        if nextOffset < count - 1 { group.append([]) }
      } else {
        group[group.count - 1].append(nextElement)
      }
      return group
    }
  }
}
