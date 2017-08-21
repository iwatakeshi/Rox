//
//  rox.number.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/20/17.
//
//

import Foundation

public protocol RoxNumberType {
  init(_ value: Int)
  init(_ value: Double)
  static func +(lhs: Self, rhs: Self) -> Self
  static func -(lhs: Self, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Self) -> Self
  static func /(lhs: Self, rhs: Self) -> Self
  static func %(lhs: Self, rhs: Self) -> Self
}

public class RoxNumber: RoxNumberType, CustomStringConvertible, CustomDebugStringConvertible {

  private(set) var value: Any = 0
  public var description: String { return "\(value)" }
  public var debugDescription: String { return "\(value)" }
  
  public required init(_ value: Any) {
    self.value = value
  }
  
  public required init(_ value: RoxNumber) {
    self.value = value.value
  }

  public required init(_ value: Int) {
    self.value = value
  }

  public required init(_ value: Double) {
    self.value = value
  }
  
  public static func +(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(add(a: lhs, b: rhs))
  }
  
  public static func /(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(divide(a: lhs, b: rhs))
  }

  public static func *(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(multiply(a: lhs, b: rhs))
  }

  public static func -(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(subtract(a: lhs, b: rhs))
  }
  public static func %(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(subtract(a: lhs, b: rhs))
  }

  static func add(a : RoxNumber, b: RoxNumber) -> RoxNumber {
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) + (b.value as! Int))
    }
    return RoxNumber((a.value as! Double) + (b.value as! Double))
  }
  
  static func subtract(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) - (b.value as! Int))
    }
    return RoxNumber((a.value as! Double) - (b.value as! Double))
  }
  
  static func multiply(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) * (b.value as! Int))
    }
    return RoxNumber((a.value as! Double) * (b.value as! Double))
  }

  static func divide(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) / (b.value as! Int))
    }
    return RoxNumber((a.value as! Double) / (b.value as! Double))
  }

  static func mod(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) % (b.value as! Int))
    }
    return RoxNumber((a.value as! Double).truncatingRemainder(dividingBy: (b.value as! Double)))
  }
  
}
