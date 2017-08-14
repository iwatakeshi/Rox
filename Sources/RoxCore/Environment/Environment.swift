//
//  Environment.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/13/17.
//
//

import Foundation

public class Environment {
  private(set) var values = Dictionary<String, Any?>()
  
  public func define(_ name: String, value: Any?) {
    values[name] = value
  }
  
  public func get(_ name: Token) throws -> Any? {
    if values[name.lexeme] {
      return values[name.lexeme]
    }
    throw new RoxException.RoxRuntimeException())
  }
  
}

