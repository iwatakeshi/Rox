//
//  Environment.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/13/17.
//
//

import Foundation

public class Environment {
  private(set) var enclosing: Environment?
  private(set) var values = Dictionary<String, Any?>()
  
  public init() {}
  
  public init(_ environment: Environment) {
    self.enclosing = environment
  }
  
  
  
  public func define(_ name: String, _ value: Any?) {
    values[name] = value
  }
  
  public func get(_ name: Token) throws -> Any? {
    if values[name.lexeme] != nil {
      return values[name.lexeme]! ?? "null"
    }
    
    if enclosing != nil {
      return try enclosing?.get(name) ?? "null"
    }
    
    throw RoxRuntimeException.error(name, "Undefined variable '\(name.lexeme)'")
  }

  public func assign(_ name: Token, _ value: Any?) throws {
    if values[name.lexeme] != nil {
      values[name.lexeme] = value
      return
    }
    
    if enclosing != nil {
      try enclosing?.assign(name, value)
      return
    }
    
    throw RoxRuntimeException.error(name, "Undefined variable '\(name.lexeme)\'")
  }
  
}

