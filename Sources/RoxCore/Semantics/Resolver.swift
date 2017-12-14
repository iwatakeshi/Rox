//
//  Resolver.swift
//  Rox
//
//  Created by Takeshi Iwana on 12/13/17.
//

import Foundation

class Resolver : ExpressionVisitor, StatementVisitor {
  private(set) var interpreter: Interpreter
  private(set) var scopes = Stack<Dictionary<String, Bool>>();
  
  public init(interpreter: Interpreter) {
    self.interpreter = interpreter
  }
  
  public func visit(statement: Statement.Block) throws {
    startScope()
    resolve(statement.statements)
    endScope()
  }
  
  public func visit(statemnt: Statement.Variable) {
    declare(statemnt.name)
    if (statement.initializer != nil) {
      resolve(statement.initializer);
    }
    define(statement.name);
  }
  
  public func resolve(_ expression: Expression.Variable) {
    if scopes.isEmpty && scopes.top[expression.name.lexeme] == false {
      Rox.error(RoxRuntimeException(expression.name, "Cannot read local variable in its own initializer"))
    }
    resolveLocal(expression, expression.name);
  }
  
  public func resolve(_ statements: [Statement]) {
    for statement in statements {
      resolve(statement);
    }
  }
  
  private func resolve(_ statement: Statement) throws {
    try? statement.accept(visitor: self);
  }
  
  private func resolveLocal(_ expression: Expression, name: Token) {
    for i in scopes.count - 1...0 {
      if scopes[i][name.lexeme] {
        
      }
    }
  }
  
  private func startScope() {
    scopes.push(Dictionary<String, Bool>());
  }
  
  private func endScope() {
    scopes.pop();
  }
  
  private func declare(_ name: Token) {
    if scopes.isEmpty {
      return;
    }
    var scope = scopes.top;
    scope[name.lexeme] = false;
  }
  
  private func define(_ name: Token) {
    if scopes.isEmpty {
      return;
    }
    (scopes.top)[name.lexeme] = true;
  }
  
}
