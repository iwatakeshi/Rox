//
//  stack.swift
//  Rox
//
//  Created by Takeshi Iwana on 12/13/17.
//

import Foundation

struct Stack<Element> {
  private var items = [Element]();
  mutating func push(_ item: Element) {
    items.append(item);
  }
  mutating func pop() -> Element {
    return items.removeLast();
  }
  
  var top: Element? {
    return items.isEmpty ? nil : items[items.count - 1];
  }
  
  var isEmpty: Bool {
    return items.isEmpty;
  }
  
  var count: Int {
    return items.count;
  }
}


extension Stack {
  subscript (position: Index) -> Element {
    precondition(items.count > position, "Index out of bounds.")
    let dictionaryElement = items[position]
    return (element: dictionaryElement.key, count: dictionaryElement.value)
  }
}
