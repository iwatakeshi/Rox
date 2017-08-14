//
//  File.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/10/17.
//
//

import Foundation

public extension Bool {
  public init(_ value: Any?) {
    if value == nil { self.init(false) }
    else if value is Bool { self.init(value as! Bool) }
    else if value is String {
      let text = (value as! String)
      let truthy = text == "true"
      self.init(truthy)
    } else {
      self.init()
    }
  }
}
