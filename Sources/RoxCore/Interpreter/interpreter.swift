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

  private(set) var globals = Environment()
  private(set) var locals = Dictionary<Expression, Int>()
  private(set) var environment: Environment
  
  public init() {
    globals.define("clock", RoxCallable("clock", { (arg1: Interpreter, arg2: [Any?]) -> Any? in
      return Date().millisecondsSince1970
    }))
    
    environment = globals
  }
  
  @discardableResult
  public func interpret(_ syntax: Any?) throws -> Any? {
    if syntax is Expression {
      return try evaluate(syntax as! Expression) ?? nil
    }
    if syntax is [Statement] {
      for statement in (syntax as! [Statement]) {
        try execute(statement)
      }
    }
    return nil
  }
  
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
  
  public func resolve(_ expression: Expression, _ depth: Int) {
    locals[expression] = depth;
  }
  
  public func lookupVariable(_ expression: Expression, _ name: Token) throws -> Any? {
    let distance = locals[expression];
    if distance != nil && distance! >= 0 {
      return environment.getAt(distance!, name.lexeme)
    }
    return try? globals.get(name)!
  }
  
  /* Expressions */
  
  public func visit(expression: Expression.Assignment) throws -> Any? {
    let value = try evaluate(expression.value)
    
    let distance = locals[expression]
    if distance != nil && distance! >= 0 {
      environment.assignAt(distance!, expression.name, value as Any)
    } else {
      try globals.assign(expression.name, value)
    }
    
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
      if left is RoxNumberType && right is RoxNumberType {
        return try evaluateNumber(expression.operator, left, right)
      }
      if (left is String || right is String) && (left is RoxNumberType || right is RoxNumberType) {
        return castString(left) + castString(right)
      }
      break
    case .Operator("-"): fallthrough
    case .Operator("/"): fallthrough
    case .Operator("*"):
      try checkNumberOperands(expression.operator, left, right)
        return try evaluateNumber(expression.operator, left, right)
    case .Operator("=="):
      if left is String && right is String {
        return castString(left) == castString(right)
      }
      if left is RoxNumberType && right is RoxNumberType {
        return RoxNumber(left!) == RoxNumber(right!)
      }
      if left is Bool && right is Bool {
        return castBool(left) == castBool(right)
      }
      return false
    case .Operator("!="):
      if left is String && right is String {
        return castString(left) != castString(right)
      }
      if (left is RoxNumberType && right is RoxNumberType) {
        return RoxNumber(left!) != RoxNumber(right!)
      }
      if (left is Bool && right is Bool) {
        return castBool(left) != castBool(right)
      }
      return true
    case .Operator(">"):
      try checkNumberOperands(expression.operator, left, right)
        return RoxNumber(left!) > RoxNumber(right!)
    case .Operator(">="):
      try checkNumberOperands(expression.operator, left, right)
      return RoxNumber(left!) >= RoxNumber(right!)
    case .Operator("<"):
      try checkNumberOperands(expression.operator, left, right)
      return RoxNumber(left!) < RoxNumber(right!)
    case .Operator("<="):
      try checkNumberOperands(expression.operator, left, right)
      return RoxNumber(left!) <= RoxNumber(right!)
      
    default: break;
    }
    throw RoxRuntimeException.error(expression.operator, "Operands must be two numbers or two strings")
  }
  
  public func visit(expression: Expression.Call) throws -> Any? {
    let callee = try evaluate(expression.callee)
    var arguments = [Any?]()
    
    for argument in expression.arguments {
      arguments.append(try evaluate(argument))
    }
    
    if !(callee is RoxCallableType) {
      throw RoxRuntimeException.error(expression.parenthesis, "Can only call functions and classes")
    }
    
    let function = callee as! RoxCallableType
    
    if (arguments.count != function.arity) {
      throw RoxRuntimeException.error(expression.parenthesis, "Expected \(function.arity) arguments but got \(arguments.count)")
    }
    
    if let value = try function.call!(self, arguments) {
      return value
    }
    return nil
  }
  
  public func visit(expression: Expression.Function) throws -> Any? {
    let function = RoxFunction(expression, environment)
    return function
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
    let left = expression.left == nil ? 0 : try evaluate(expression.left!)
    let right = expression.right == nil ? 0 : try evaluate(expression.right!)
    
    if left is RoxNumberType && right is RoxNumberType {
      
      // Int && Int
      if left is Int && right is Int {
        return RoxRange(RoxNumber(left as! Int), RoxNumber(right as! Int), 1)
      }
      
      return RoxRange(RoxNumber(left!), RoxNumber(right!), 0.1)

    }
    throw RoxRuntimeException.error(expression.operator, "Operands must be numbers of the same type")
  }
  
  public func visit(expression: Expression.Unary) throws -> Any? {
    let right = try evaluate(expression.right)
    switch expression.operator.type {
    case .Operator("-"):
      try checkNumberOperand(expression.operator, right)
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
  public func evaluate(_ expression: Expression) throws -> Any? {
    return try expression.accept(visitor: self)
  }
  
  /* Statements */
  
  public func visit(statement: Statement.Block) throws {
    try execute(statement.statements, Environment(environment))
  }
  
  public func visit(statement: Statement.Expression) throws {
    try evaluate(statement.expression);
  }
  
  public func visit(statement: Statement.For) throws {

    if statement.expression is Expression.Range {
      let expression = (statement.expression as! Expression.Range)
      let value = (try evaluate(expression) as! RoxRange);
      var index = 0
      for (element) in value {
        self.environment.define((statement.name?.lexeme)!, element)
        if statement.index != nil {
          self.environment.define((statement.index?.lexeme)!, index)
          index = index + 1
        }
        try execute(statement.body)
      }
    }
    
//    print("warn: for-loop not implemented")
  }
  
  public func visit(statement: Statement.Function) throws {
    let function = RoxFunction(statement.name.lexeme, statement.function, environment)
    environment.define(statement.name.lexeme, function)
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
    print(value ?? "null")
  }
  
  public func visit(statement: Statement.Return) throws {
    var value: Any?
    if (statement.value != nil) {
      value = try evaluate(statement.value!)
//      print(value ?? "")
    }
    throw RoxReturnException.return(value)
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
  
  public func execute(_ block: [Statement], _ environment: Environment) throws {
    let previous = self.environment
    defer {
      self.environment = previous
    }
    do  {
      self.environment = environment
      for (_, statement) in block.enumerated() {
        try execute(statement)
      }
    }
    
  }
  
  /* Helpers */
  
  private func isTruthy(_ value: Any?) -> Bool {
    if value == nil { return false }
    return castBool(value)
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
      return RoxNumber(left!) + RoxNumber(right!)
    case .Operator("-"):
      return RoxNumber(left!) - RoxNumber(right!)
    case .Operator("*"):
      return RoxNumber(left!) * RoxNumber(right!)
    case .Operator("/"):
      if RoxNumber(right!) == 0 {
        throw RoxRuntimeException.error(`operator`, "Cannot divide by 0")
      }
      return RoxNumber(left!) / RoxNumber(right!)
    default: return nil
    }
  }
  
  private func castBool(_ value: Any?) -> Bool {
    if value is Bool { return value as! Bool }
    return String(describing: value ?? "null").contains("true")
  }
  
  private func castString(_ value: Any?) -> String {
    if value == nil { return "" }
    if value is Int { return String(value as! Int) }
    if value is Double { return String(value as! Double) }
    
    return value as! String
  }
  
  private func checkNumberOperand(_ `operator`: Token, _ operand: Any?) throws {
    if operand is RoxNumberType { return }
    throw RoxRuntimeException.error(`operator`, "Operand must be a number")
  }
  
  private func checkNumberOperands(_ `operator`: Token, _ left: Any?, _ right: Any?) throws {
    if left is RoxNumberType && right is RoxNumberType { return }
    throw RoxRuntimeException.error(`operator`, "Operands must be numbers")
  }
  
}
