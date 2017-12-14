//
//  string.extension.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation

extension String {
  
  /* subscripts */
  // https://stackoverflow.com/a/38215613/1251031
  subscript(pos: Int) -> String {
    precondition(pos >= 0, "character position can't be negative")
    return self[pos...pos]
  }
  subscript(range: Range<Int>) -> String {
    precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
    let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
    return String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)])
  }
  subscript(range: ClosedRange<Int>) -> String {
    precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
    let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
    return String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)])
  }
  
  func substring(_ range: Range<Int>) -> String {
    let fromIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
    let toIndex = self.index(self.startIndex, offsetBy: range.upperBound)
    return String(self[fromIndex...toIndex])
  }
  
  func substring(_ from: Int, to: Int) -> String {
    let fromIndex = self.index(self.startIndex, offsetBy: from)
    let toIndex = self.index(self.startIndex, offsetBy: to)
    return String(self[fromIndex...toIndex])
  }
  
  var first: String {
    get { return self.count > 0 ? self[0] : "" }
  }
  
  var last: String {
    get { return self.count > 0 ? self[self.count - 1] : "" }
  }
  
  func toArray() -> Array<Character> {
    return self.count > 0 ? Array(self) : ["\0"]
  }
}
