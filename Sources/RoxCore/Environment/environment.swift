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
  
  public func getAt(_ distance: Int, _ name: String) -> Any? {
    return ancestor(distance).values[name] as Any;
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
  
  public func assignAt(_ distance: Int, _ name: Token, _ value: Any) {
    ancestor(distance).values[name.lexeme] = value;
  }
  
  public func ancestor(_ distance: Int) -> Environment {
    var environment = self
    for _ in 0...distance {
      environment = environment.enclosing!
    }
    return environment
  }
  
}

