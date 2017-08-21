//
//  number.ext.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/20/17.
//
//

import Foundation

extension Double : RoxNumberType {
  init(_ number: RoxNumber) {
    if number.value is Int {
      self.init(Double(number.value as! Int))
    } else {
      self.init(number.value as! Double)
    }
  }
}
extension Float  : RoxNumberType { }
extension Int    : RoxNumberType {
  init(_ number: RoxNumber) {
    if number.value is Int {
      self.init(number.value as! Int)
    }
    else {
      self.init(Int(number.value as! Double))
    }
  }
}
extension Int8   : RoxNumberType { }
extension Int16  : RoxNumberType { }
extension Int32  : RoxNumberType { }
extension Int64  : RoxNumberType { }
extension UInt   : RoxNumberType { }
extension UInt8  : RoxNumberType { }
extension UInt16 : RoxNumberType { }
extension UInt32 : RoxNumberType { }
extension UInt64 : RoxNumberType { }
