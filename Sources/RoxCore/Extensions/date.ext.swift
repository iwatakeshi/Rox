//
//  date.ext.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/15/17.
//
//

import Foundation

// https://stackoverflow.com/a/40135192/1251031
public extension Date {
  var millisecondsSince1970:Int {
    return Int((self.timeIntervalSince1970 * 1000.0).rounded())
  }
  
  init(milliseconds:Int) {
    self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
  }
}
