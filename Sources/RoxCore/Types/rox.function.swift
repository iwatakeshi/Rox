//
//  RoxFunction.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/15/17.
//
//

import Foundation

protocol RoxCallableType {
  var name: String? { get }
  var arity: Int { get }
  var call: ((_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?)? { get }
}

class RoxCallable: RoxCallableType {
  internal(set) var name: String?
  internal(set) var arity: Int
  internal(set) var call: ((_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?)?
  
  init() {
    self.arity = 0;
    self.call = nil;
  }
  
  init(_ name: String, _ arity: Int, _ call: @escaping (_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?) {
    self.name = name;
    self.arity = arity
    self.call = call
  }
  
  init(_ name: String, _ call: @escaping (_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?) {
    self.name = name;
    self.arity = 0
    self.call = call
  }
  
  init(_ call: @escaping (_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?) {
    self.arity = 0
    self.call = call
  }
}

class RoxFunction: RoxCallableType {
  private(set) var declaration: Expression.Function
  private(set) var closure: Environment
  internal(set) var name: String?
  internal(set) var arity: Int
  internal(set) var call: ((_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?)?
  init(_ declaration: Expression.Function, _ closure: Environment) {
    self.declaration = declaration
    self.closure = closure
    self.arity = declaration.parameters.count
    self.call = { (interpreter: Interpreter, arguments: [Any?]) throws -> Any? in
      let environment = Environment(closure)
      for (index, parameter) in declaration.parameters.enumerated() {
        environment.define(parameter.lexeme, arguments[index])
      }
      do {
        try interpreter.execute(declaration.body, environment)
      } catch RoxReturnException.return(let value) {
        return value
      }
      return nil
    }
  }
  convenience init(_ name: String, _ declaration: Expression.Function, _ closure: Environment) {
    self.init(declaration, closure)
    self.name = name
  }
  
}
