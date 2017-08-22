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
}


public class RoxNumber: RoxNumberType, CustomStringConvertible, CustomDebugStringConvertible, Equatable {

  public private(set) var value: Any = 0
  public var description: String { return "\(value)" }
  public var debugDescription: String { return "\(value)" }
  
  public required init(_ value: Any) {
    if value is Double || value is Int {
      self.value = value
    }
    if value is RoxNumber {
      self.value = (value as! RoxNumber).value
    }
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
  
  /* Arithmetic */
  
  // +
  
  public static func +(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(add(a: lhs, b: rhs))
  }
  
  public static func +(lhs: RoxNumber, rhs: Int) -> Self {
    if lhs.value is Int {
      return self.init((lhs.value as! Int) + rhs)
    }
    return self.init((lhs.value as! Double) + Double(rhs))
  }
  
  public static func +(lhs: Int, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs + (rhs.value as! Int))
    }
    return self.init(Double(lhs) + (rhs.value as! Double))
  }
  
  public static func +(lhs: RoxNumber, rhs: Double) -> Self {
    if lhs.value is Int {
      return self.init(Double((lhs.value as! Int)) + rhs)
    }
    return self.init((lhs.value as! Double) + rhs)
  }
  
  public static func +(lhs: Double, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs + Double((rhs.value as! Int)))
    }
    return self.init(lhs + (rhs.value as! Double))
  }
  
  // -
  
  public static func -(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(subtract(a: lhs, b: rhs))
  }
  
  public static func -(lhs: RoxNumber, rhs: Int) -> Self {
    if lhs.value is Int {
      return self.init((lhs.value as! Int) - rhs)
    }
    return self.init((lhs.value as! Double) - Double(rhs))
  }
  
  public static func -(lhs: Int, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs - (rhs.value as! Int))
    }
    return self.init(Double(lhs) - (rhs.value as! Double))
  }
  
  public static func -(lhs: RoxNumber, rhs: Double) -> Self {
    if lhs.value is Int {
      return self.init(Double((lhs.value as! Int)) - rhs)
    }
    return self.init((lhs.value as! Double) - rhs)
  }
  
  public static func -(lhs: Double, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs - Double((rhs.value as! Int)))
    }
    return self.init(lhs - (rhs.value as! Double))
  }
  
  // *
  
  public static func *(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(multiply(a: lhs, b: rhs))
  }
  
  public static func *(lhs: RoxNumber, rhs: Int) -> Self {
    if lhs.value is Int {
      return self.init((lhs.value as! Int) * rhs)
    }
    return self.init((lhs.value as! Double) * Double(rhs))
  }
  
  public static func *(lhs: Int, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs * (rhs.value as! Int))
    }
    return self.init(Double(lhs) * (rhs.value as! Double))
  }
  
  public static func *(lhs: RoxNumber, rhs: Double) -> Self {
    if lhs.value is Int {
      return self.init(Double((lhs.value as! Int)) * rhs)
    }
    return self.init((lhs.value as! Double) * rhs)
  }
  
  public static func *(lhs: Double, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs * Double((rhs.value as! Int)))
    }
    return self.init(lhs * (rhs.value as! Double))
  }
  
  // /
  public static func /(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(divide(a: lhs, b: rhs))
  }
  
  public static func /(lhs: RoxNumber, rhs: Int) -> Self {
    if lhs.value is Int {
      return self.init(Double((lhs.value as! Int)) / Double(rhs))
    }
    return self.init((lhs.value as! Double) / Double(rhs))
  }
  
  public static func /(lhs: Int, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(Double(lhs) / Double((rhs.value as! Int)))
    }
    return self.init(Double(lhs) / (rhs.value as! Double))
  }
  
  public static func /(lhs: RoxNumber, rhs: Double) -> Self {
    if lhs.value is Int {
      return self.init(Double((lhs.value as! Int)) / rhs)
    }
    return self.init((lhs.value as! Double) / rhs)
  }
  
  public static func /(lhs: Double, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs / Double((rhs.value as! Int)))
    }
    return self.init(lhs / (rhs.value as! Double))
  }
  
  public static func %(lhs: RoxNumber, rhs: RoxNumber) -> Self {
    return self.init(subtract(a: lhs, b: rhs))
  }
  
  public static func %(lhs: RoxNumber, rhs: Int) -> Self {
    if lhs.value is Int {
      return self.init((lhs.value as! Int) % rhs)
    }
    return self.init((lhs.value as! Double).truncatingRemainder(dividingBy: Double(rhs)))
  }
  
  public static func %(lhs: Int, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs % (rhs.value as! Int))
    }
    return self.init(Double(lhs).truncatingRemainder(dividingBy: (rhs.value as! Double)))
  }
  
  public static func %(lhs: RoxNumber, rhs: Double) -> Self {
    if lhs.value is Int {
      return self.init(Double((lhs.value as! Int)).truncatingRemainder(dividingBy:rhs))
    }
    return self.init((lhs.value as! Double).truncatingRemainder(dividingBy: rhs))
  }
  
  public static func %(lhs: Double, rhs: RoxNumber) -> Self {
    if rhs.value is Int {
      return self.init(lhs.truncatingRemainder(dividingBy: Double((rhs.value as! Int))))
    }
    return self.init(lhs.truncatingRemainder(dividingBy: rhs.value as! Double))
  }
  
  
  /* Equality */
  
  // ==
  
  public static func ==(lhs: RoxNumber, rhs: RoxNumber) -> Bool {
    return castToDouble(lhs) == castToDouble(rhs)
  }
  
  public static func ==(lhs: RoxNumber, rhs: Double) -> Bool {
    return castToDouble(lhs) == rhs
  }
  
  public static func ==(lhs: Double, rhs: RoxNumber) -> Bool {
    return lhs == castToDouble(rhs)
  }
  
  public static func ==(lhs: RoxNumber, rhs: Int) -> Bool {
    return castToDouble(lhs) == Double(rhs)
  }
  
  public static func ==(lhs: Int, rhs: RoxNumber) -> Bool {
    return Double(lhs) == castToDouble(rhs)
  }
  
  // !=
  
  public static func !=(lhs: RoxNumber, rhs: RoxNumber) -> Bool {
    return castToDouble(lhs) != castToDouble(rhs)
  }
  
  public static func !=(lhs: RoxNumber, rhs: Double) -> Bool {
    return castToDouble(lhs) != rhs
  }
  
  public static func !=(lhs: Double, rhs: RoxNumber) -> Bool {
    return lhs != castToDouble(rhs)
  }
  
  public static func !=(lhs: RoxNumber, rhs: Int) -> Bool {
    return castToDouble(lhs) != Double(rhs)
  }
  
  public static func !=(lhs: Int, rhs: RoxNumber) -> Bool {
    return Double(lhs) != castToDouble(rhs)
  }
  
  // >
  
  public static func >(lhs: RoxNumber, rhs: RoxNumber) -> Bool {
    return castToDouble(lhs) > castToDouble(rhs)
  }
  
  public static func >(lhs: RoxNumber, rhs: Double) -> Bool {
    return castToDouble(lhs) > rhs
  }
  
  public static func >(lhs: Double, rhs: RoxNumber) -> Bool {
    return lhs > castToDouble(rhs)
  }
  
  public static func >(lhs: RoxNumber, rhs: Int) -> Bool {
    return castToDouble(lhs) > Double(rhs)
  }
  
  public static func >(lhs: Int, rhs: RoxNumber) -> Bool {
    return Double(lhs) > castToDouble(rhs)
  }
  
  // >=
  
  public static func >=(lhs: RoxNumber, rhs: RoxNumber) -> Bool {
    return castToDouble(lhs) >= castToDouble(rhs)
  }
  
  public static func >=(lhs: RoxNumber, rhs: Double) -> Bool {
    return castToDouble(lhs) >= rhs
  }
  
  public static func >=(lhs: Double, rhs: RoxNumber) -> Bool {
    return lhs >= castToDouble(rhs)
  }
  
  public static func >=(lhs: RoxNumber, rhs: Int) -> Bool {
    return castToDouble(lhs) >= Double(rhs)
  }
  
  public static func >=(lhs: Int, rhs: RoxNumber) -> Bool {
    return Double(lhs) >= castToDouble(rhs)
  }
  
  // <
  
  public static func <(lhs: RoxNumber, rhs: RoxNumber) -> Bool {
    return castToDouble(lhs) < castToDouble(rhs)
  }
  
  public static func <(lhs: RoxNumber, rhs: Double) -> Bool {
    return castToDouble(lhs) < rhs
  }
  
  public static func <(lhs: Double, rhs: RoxNumber) -> Bool {
    return lhs < castToDouble(rhs)
  }
  
  public static func <(lhs: RoxNumber, rhs: Int) -> Bool {
    return castToDouble(lhs) < Double(rhs)
  }
  
  public static func <(lhs: Int, rhs: RoxNumber) -> Bool {
    return Double(lhs) < castToDouble(rhs)
  }
  
  // <=
  
  public static func <=(lhs: RoxNumber, rhs: RoxNumber) -> Bool {
    return castToDouble(lhs) <= castToDouble(rhs)
  }
  
  public static func <=(lhs: RoxNumber, rhs: Double) -> Bool {
    return castToDouble(lhs) <= rhs
  }
  
  public static func <=(lhs: Double, rhs: RoxNumber) -> Bool {
    return lhs <= castToDouble(rhs)
  }
  
  public static func <=(lhs: RoxNumber, rhs: Int) -> Bool {
    return castToDouble(lhs) <= Double(rhs)
  }
  
  public static func <=(lhs: Int, rhs: RoxNumber) -> Bool {
    return Double(lhs) <= castToDouble(rhs)
  }

  private static func add(a : RoxNumber, b: RoxNumber) -> RoxNumber {
    // Int && Int
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) + (b.value as! Int))
    }
    // Int && Double
    if a.value is Int && b.value is Double {
      return RoxNumber(Double(a.value as! Int) + (b.value as! Double))
    }
    // Double && Int
    if a.value is Double && b.value is Int {
      return RoxNumber((a.value as! Double) + Double(b.value as! Int))
    }
    // Double && Double
    return RoxNumber((a.value as! Double) + (b.value as! Double))
  }
  
  private static func subtract(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    // Int && Int
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) - (b.value as! Int))
    }
    // Int && Double
    if a.value is Int && b.value is Double {
      return RoxNumber(Double(a.value as! Int) - (b.value as! Double))
    }
    // Double && Int
    if a.value is Double && b.value is Int {
      return RoxNumber((a.value as! Double) - Double(b.value as! Int))
    }
    // Double && Double
    return RoxNumber((a.value as! Double) - (b.value as! Double))
  }
  
  private static func multiply(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    // Int && Int
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) * (b.value as! Int))
    }
    // Int && Double
    if a.value is Int && b.value is Double {
      return RoxNumber(Double(a.value as! Int) * (b.value as! Double))
    }
    // Double && Int
    if a.value is Double && b.value is Int {
      return RoxNumber((a.value as! Double) * Double(b.value as! Int))
    }
    // Double && Double
    return RoxNumber((a.value as! Double) * (b.value as! Double))
  }

  private static func divide(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    // Int && Int
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) / (b.value as! Int))
    }
    // Int && Double
    if a.value is Int && b.value is Double {
      return RoxNumber(Double(a.value as! Int) / (b.value as! Double))
    }
    // Double && Int
    if a.value is Double && b.value is Int {
      return RoxNumber((a.value as! Double) / Double(b.value as! Int))
    }
    // Double && Double
    return RoxNumber((a.value as! Double) / (b.value as! Double))
  }

  private static func mod(a: RoxNumber, b: RoxNumber) -> RoxNumber {
    // Int && Int
    if a.value is Int && b.value is Int {
      return RoxNumber((a.value as! Int) % (b.value as! Int))
    }
    // Int && Double
    if a.value is Int && b.value is Double {
      return RoxNumber(Double(a.value as! Int).truncatingRemainder(dividingBy: (b.value as! Double)))
    }
    // Double && Int
    if a.value is Double && b.value is Int {
      return RoxNumber((a.value as! Double).truncatingRemainder(dividingBy: Double(b.value as! Int)))
    }
    // Double && Double
    return RoxNumber((a.value as! Double).truncatingRemainder(dividingBy: (b.value as! Double)))
  }
  
  public static func castToDouble(_ number: RoxNumber) -> Double {
    if number.value is Int {
      return Double(number.value as! Int)
    }
    return number.value as! Double
  }
  
}
