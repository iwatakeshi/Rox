//
//  stack.swift
//  Rox
//
//  Created by Takeshi Iwana on 12/13/17.
//

import Foundation
/*
 Last-in first-out stack (LIFO)
 Push and pop are O(1) operations.
 */
public struct Stack<T> {
  fileprivate var array = [T]()
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func push(_ element: T) {
    array.append(element)
  }
  
  @discardableResult
  public mutating func pop() -> T? {
    return array.popLast()
  }
  
  public var top: T? {
    get {
      return array.last
    }
    set(newValue) {
      array[array.count - 1] = newValue!;
    }
  }
}

extension Stack: Sequence {
  public func makeIterator() -> AnyIterator<T> {
    var curr = self
    return AnyIterator {
      return curr.pop()
    }
  }
  subscript (position: Int) -> T {
    get {
      precondition(position <= array.count, "Index out of bounds.")
      return array[position]
    }
    set (newValue) {
      precondition(position <= array.count, "Index out of bounds.")
      array[position] = newValue;
    }
  }
}
