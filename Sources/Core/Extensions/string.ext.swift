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
    return self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
  }
  subscript(range: ClosedRange<Int>) -> String {
    precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
    let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
    return self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
  }
  
  func substring(_ range: Range<Int>) -> String {
    let fromIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
    let toIndex = self.index(self.startIndex, offsetBy: range.upperBound)
    return self.substring(with: Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex)))
  }
  
  func substring(_ from: Int, to: Int) -> String {
    let fromIndex = self.index(self.startIndex, offsetBy: from)
    let toIndex = self.index(self.startIndex, offsetBy: to)
    return self.substring(with: Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex)))
  }
  
  var count: Int {
    get { return self.characters.count }
  }
  
  func toArray() -> Array<Character> {
    return self.count > 0 ? Array(self.characters) : ["\0"]
  }
}
