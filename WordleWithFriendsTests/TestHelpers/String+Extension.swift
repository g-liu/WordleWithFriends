//
//  String+Extension.swift
//  WordleWithFriendsTests
//
//  Created by Geoffrey Liu on 3/13/22.
//

import Foundation

extension String {
  var asInt: Int? { .init(self) }
  var asFloat: Float? { .init(self) }
  var asDouble: Double? { .init(self) }
  var asTimeInterval: TimeInterval? { .init(self) }
  var asBool: Bool? { .init(self) }
}

extension Substring {
  var asString: String { .init(self) }
}
