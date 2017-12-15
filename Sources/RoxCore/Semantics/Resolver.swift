//
//  Resolver.swift
//  Rox
//
//  Created by Takeshi Iwana on 12/13/17.
//

import Foundation

class Resolver : ExpressionVisitor, StatementVisitor {
  public enum FunctionType {
    case None
    case Function
    case Method
  }
  private(set) var interpreter: Interpreter
  private(set) var scopes = Stack<Dictionary<String, Bool>>();
  private(set) var currentFunctionType = FunctionType.None
  
  
  public init(_ interpreter: Interpreter) {
    self.interpreter = interpreter
  }
  
  func visit(expression: Expression.Assignment) throws -> Any? {
    resolve(expression.value)
    resolveLocal(expression, expression.name);
    return nil
  }
  
  func visit(expression: Expression.Binary) throws -> Any? {
    return nil
  }
  
  func visit(expression: Expression.Call) throws -> Any? {
    resolve(expression.callee)
    
    for argument in expression.arguments {
      resolve(argument)
    }
    
    return nil
  }

  func visit(expression: Expression.Get) throws -> Any? {
    return nil
  }
  
  func visit(expression: Expression.Function) throws -> Any? {
    return nil
  }
  
  func visit(expression: Expression.Literal) throws -> Any? {
    return nil
  }
  
  func visit(expression: Expression.Logical) throws -> Any? {
    return nil
  }
  
  func visit(expression: Expression.Set) throws -> Any? {
    resolve(expression.value)
    resolve(expression.object)
    return nil
  }

  func visit(expression: Expression.Parenthesized) throws -> Any? {
    resolve(expression.expression)
    return nil
  }
  
  func visit(expression: Expression.Range) throws -> Any? {
    return nil
  }
  
  func visit(expression: Expression.Unary) throws -> Any? {
    resolve(expression.right)
    return nil
  }
  
  func visit(expression: Expression.Variable) throws -> Any? {
    return nil
  }
  
  func visit(statement: Statement.Block) throws {
    startScope()
    resolve(statement.statements)
    endScope()
  }

  func visit(statement: Statement.Class) throws {
    declare(statement.name)
    define(statement.name)

    for method in statement.methods {
      let declaration = FunctionType.Method
      resolveFunction(method, declaration)
    }
  }
  
  func visit(statement: Statement.Expression) throws {
    resolve(statement.expression)
  }
  
  func visit(statement: Statement.Function) throws {
    declare(statement.name)
    define(statement.name)
    resolveLocal(statement.function, statement.name)
  }
  
  func visit(statement: Statement.For) throws {
    
  }
  
  func visit(statement: Statement.If) throws {
    resolve(statement.condition)
    try? resolve(statement.then)
    
    if statement.else != nil {
      try? resolve(statement.else!)
    }
  }
  
  func visit(statement: Statement.Print) throws {
    resolve(statement.expression)
  }
  
  func visit(statement: Statement.Return) throws {
    if currentFunctionType == .None {
      Rox.error(RoxException.RoxSemanticException(RoxSemanticException.error(statement.keyword, "Cannot return from top-level code")))
    }
    if statement.value != nil {
      resolve(statement.value!)
    }
  }
  
  func visit(statement: Statement.Variable) throws {
    declare(statement.name)
    if (statement.value != nil) {
      resolve(statement.value!);
    }
    define(statement.name);
  }
  
  func visit(statement: Statement.While) throws {
    resolve(statement.condition)
    try? resolve(statement.body)
  }
  
  public func resolve(_ expression: Expression.Variable) {
    if scopes.isEmpty && scopes.top![expression.name.lexeme] == false {
      Rox.error(RoxException.RoxSemanticException(RoxSemanticException.error(expression.name, "Cannot read local variable in its own initializer")));
    }
    resolveLocal(expression, expression.name);
  }
  
  public func resolve(_ expression: Expression) {
    _ = try? expression.accept(visitor: self);
  }
  
  public func resolve(_ statements: [Statement]) {
    for statement in statements {
      try? resolve(statement);
    }
  }
  
  private func resolve(_ statement: Statement) throws {
    try? statement.accept(visitor: self);
  }
  
  private func resolveLocal(_ expression: Expression, _ name: Token) {
    if !scopes.isEmpty {
      for i in scopes.count - 1...0 {
        if scopes[i][name.lexeme] != nil {
          interpreter.resolve(expression, scopes.count - 1 - i)
        }
      }
    }
  }
  
  private func resolveFunction(_ function: Statement.Function, _ type: FunctionType) {
    let enclosingFunctionType = currentFunctionType;
    currentFunctionType = type;
    startScope()
    for param in function.function.parameters {
      declare(param)
      define(param)
    }
    resolve(function.function.body)
    endScope()
    currentFunctionType = enclosingFunctionType
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
    scopes.top?.updateValue(true, forKey: name.lexeme)
  }
  
  private func define(_ name: Token) {
    if scopes.isEmpty {
      return;
    }
    var scope = scopes.top
    
    if scope![name.lexeme] != nil {
      Rox.error(RoxException.RoxSemanticException(RoxSemanticException.error(name, "Variable with this name already declared in this scope")))
    }
    
    scopes.top?.updateValue(true, forKey: name.lexeme)
  }
  
}
