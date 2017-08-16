//
//  RoxFunction.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/15/17.
//
//

import Foundation

protocol RoxCallable {
  var name: String? { get }
  var arity: Int { get }
  var call: (_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any? { get }
}

class RoxFunction: RoxAny, RoxCallable {
  private(set) var arity: Int = 0
  private(set) var call: (Interpreter, [Any?]) throws -> Any?
  private(set) var name: String?
  
  init(_ name: String, _ call: @escaping (_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?) {
    self.name = name
    self.call = call
  }
  
  init(_ name: String, _ arity: Int, _ call: @escaping (_ interpreter: Interpreter, _ arguments: [Any?]) throws -> Any?) {
    self.name = name
    self.arity = arity
    self.call = call
  }

  
  
}
