//
//  interpreter.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/10/17.
//
//

import Foundation

/**
 A class responsible of evaluating a given parse tree.
 */
public class Interpreter : ExpressionVisitor, StatementVisitor {

  private(set) var environment = Environment()

  public init() {}
  
  public func interpret(_ expression: Expression) -> Any? {
    do {
      return try evaluate(expression)
    } catch RoxRuntimeException.error(let token, let message) {
      Rox.error(.RoxRuntimeException(.error(token, message)))
      return nil
    } catch {
      return nil
    }
  }

  public func interpret(_ statements: [Statement]) {
    do {
      for statement in statements {
        try execute(statement)
      }
    } catch RoxRuntimeException.error(let token, let message) {
        Rox.error(.RoxParserException(.error(token, message)))
    } catch {
        
    }
  }
  
  /* Expressions */
  
  public func visit(expression: Expression.Assignment) throws -> Any? {
    let value = try evaluate(expression.value)
    try environment.assign(expression.name, value)
    return value
  }

  public func visit(expression: Expression.Binary) throws -> Any? {
    let left = try evaluate(expression.left)
    let right = try evaluate(expression.right)
    
    switch expression.operator.type {
    case .Operator("+"):
      if left is String && right is String {
        return (left as! String) + (right as! String)
      }
      if isNumber(left) && isNumber(right) {
        return try evaluateNumber(expression.operator, left, right)
      }
      break
    case .Operator("-"): fallthrough
    case .Operator("/"): fallthrough
    case .Operator("*"):
      if (!isNumber(left) || !isNumber(right)) { break }
        return try evaluateNumber(expression.operator, left, right)
    case .Operator("=="):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) == castNumber(right))
    case .Operator(">"):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) > castNumber(right))
    case .Operator(">="):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) >= castNumber(right))
    case .Operator("<"):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) < castNumber(right))
    case .Operator("<="):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) <= castNumber(right))
      
    default: break;
    }
    throw RoxRuntimeException.error(expression.operator, "Operands must be two numbers or two strings.")
  }
  
  public func visit(expression: Expression.Literal) throws -> Any? {
    return expression.value
  }
  
  public func visit(expression: Expression.Logical) throws -> Any? {
    let left = try evaluate(expression.left)
    if expression.operator.type == .Operator("or") {
      if (isTruthy(left)) { return left }
    } else {
      if (!isTruthy(left)) { return left}
    }
    return try evaluate(expression.right)
  }
  
  public func visit(expression: Expression.Parenthesized) throws -> Any? {
    return try evaluate(expression.expression)
  }
  
  public func visit(expression: Expression.Range) throws -> Any? {
    let left = try evaluate(expression.left)
    let right = try evaluate(expression.right)
    if isNumber(left) && isNumber(right) {
      if left is Double && right is Double {
        let a = left as! Double
        let b = right as! Double
        if a > b { return stride(from: b, to: a, by: -1) }
        else { return (a..<b) }
      }
      
      if left is Int && right is Int {
        let a = left as! Int
        let b = right as! Int
        if a > b { return stride(from: b, to: a, by: -1) }
        else { return (a..<b) }
      }
      
    }
    throw RoxRuntimeException.error(expression.operator, "Operands must be two numbers of the same type")
  }
  
  public func visit(expression: Expression.Unary) throws -> Any? {
    let right = try evaluate(expression.right)
    switch expression.operator.type {
    case .Operator("-"):
      try checkNumberOperand(expression.operator, operand: right)
      if right is Double {
        return (-(right as! Double))
      } else { return (-(right as! Int)) }
    case .Operator("!"):
      return !isTruthy(right)
    default: break
    }
    return nil
  }

  public func visit(expression: Expression.Variable) throws -> Any? {
    return try environment.get(expression.name)
  }
  
  @discardableResult
  public func evaluate(_ expression: Expression) throws -> Any {
    return try expression.accept(visitor: self)!
  }
  
  /* Statements */
  
  public func visit(statement: Statement.Block) throws {
    try execute(statement, Environment(environment))
  }
  
  public func visit(statement: Statement.Expression) throws {
    try evaluate(statement.expression);
  }
  
  public func visit(statement: Statement.For) throws {
    environment.define((statement.name?.lexeme)!, 0)
    if statement.index != nil {
      environment.define((statement.index?.lexeme)!, 0)
    }
    print("warn: for-loop not implemented")
  }
  
  public func visit(statement: Statement.If) throws {
    if isTruthy(try evaluate(statement.condition)) {
      try execute(statement.then)
    } else if statement.else != nil {
      try execute(statement.else!)
    }
  }
  
  public func visit(statement: Statement.Print) throws {
    let value = try evaluate(statement.expression)
    print(value)
  }

  public func visit(statement: Statement.Variable) throws {
    var value: Any?
    if statement.value != nil {
      value = try evaluate(statement.value!)
    }
    environment.define(statement.name.lexeme, value)
  }
  
  public func visit(statement: Statement.While) throws {
    while isTruthy(try evaluate(statement.condition)) {
      try execute(statement.body)
    }
  }
  
  public func execute(_ statement: Statement) throws {
    try statement.accept(visitor: self)
  }
  
  public func execute(_ block: Statement.Block, _ environment: Environment) throws {
    let previous = self.environment
    do  {
      self.environment = environment
      for statement in block.statements {
        try execute(statement)
      }
    } catch {
      self.environment = previous
    }
  }
  
  /* Helpers */
  
  private func isTruthy(_ value: Any?) -> Bool {
    if value == nil { return false }
    if value is Bool { return Bool(value) }
    return true
  }
  
  private func isEqual(_ a: Any?, _ b: Any?) -> Bool {
    if a == nil && b == nil { return true }
    if a == nil { return false }
    
    // Author: https://github.com/alexito4/slox
    guard type(of: a!) == type(of: b!) else {
      return false
    }
    
    if let l = a as? String, let r = b as? String {
      return l == r
    }
    
    if let l = a as? Bool, let r = b as? Bool {
      return l == r
    }
    
    if let l = a as? Double, let r = b as? Double {
      return l == r
    }
    return false
  }
  
  
  private func evaluateNumber(_ `operator`: Token, _ left: Any?, _ right: Any?) throws -> Any? {
    switch `operator`.type {
    case .Operator("+"):
      if left is Int && right is Int {
        return (left as! Int) + (right as! Int)
      }
      else { return castNumber(left) + castNumber(right) }
    case .Operator("-"):
      if left is Int && right is Int {
        return (left as! Int) - (right as! Int)
      }
      else { return castNumber(left) - castNumber(right) }
    case .Operator("*"):
      if left is Int && right is Int {
        return (left as! Int) * (right as! Int)
      }
      else { return castNumber(left) * castNumber(right) }
    case .Operator("/"):
      if castNumber(right) == Double(0) {
        throw RoxRuntimeException.error(`operator`, "Cannot divide by 0")
      }
      if left is Int && right is Int {
        return (left as! Int) / (right as! Int)
      }
      else { return castNumber(left) / castNumber(right) }
    default: return nil
    }
  }
  
  private func castNumber(_ number: Any?) -> Double {
    if number == nil { return 0 }
    if number is Int { return Double(number as! Int) }
    return number as! Double
  }
  
  private func isNumber(_ number: Any?) -> Bool {
    if number == nil { return false }
    return number is Int || number is Double
  }
  
  private func checkNumberOperand(_ `operator`: Token, operand: Any?) throws {
    if operand is Double || operand is Int { return }
    throw RoxRuntimeException.error(`operator`, operand as! String)
  }
  
  private func checkNumberOperands(_ `operator`: Token, left: Any?, right: Any?) throws {
    if (left is Int || left is Double) && (right is Int || right is Double) { return }
    throw RoxRuntimeException.error(`operator`, "Operands must be numbers")
  }
  
}
