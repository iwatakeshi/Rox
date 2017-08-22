//
//  rox.range.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/20/17.
//
//

import Foundation

public struct RoxRange: Sequence, IteratorProtocol {
  private(set) var lower: RoxNumber
  private(set) var upper: RoxNumber
  private(set) var counter: RoxNumber
  private var value: RoxNumber
  
  // TODO: Make RoxRange generic!

  public init(_ lower: RoxNumber?, _ upper: RoxNumber?, _ counter: RoxNumber?) {
    self.lower = lower ?? RoxNumber(0)
    self.upper = upper ?? RoxNumber(0)
    self.counter = counter ?? RoxNumber(1)
    self.value = self.lower
  }
  
  public init(_ lower: Any, _ upper: Any, _ counter: Any) {
    self.lower = RoxNumber(lower)
    self.upper = RoxNumber(upper)
    self.counter = RoxNumber(counter)
    self.value = self.lower
  }
  
  mutating public func next() -> RoxNumber? {

    if value < self.upper + 1 {
      defer {
        value = value + self.counter
      }
      return value
    }
    
    if value > self.upper + 1 {
      defer {
        value = value - self.counter
      }
      return value
    }
    return nil
  }
  
}
