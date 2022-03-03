//
//  WeakRef.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 3/2/22.
//

class WeakRef<T> where T: AnyObject {

  private(set) weak var value: T?

  init(value: T?) {
    self.value = value
  }
}
