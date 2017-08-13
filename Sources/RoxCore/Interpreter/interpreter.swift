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
public class Interpreter : ExpressionVisitor {
  public init() {}
  
  public func interpret(_ expression: Expression) {
    do {
      let value = try evaluate(expression)
        print(value)
    } catch RoxRuntimeException.error(let token, let message) {
        Rox.error(.RoxParserException(.error(token, message)))
    } catch {
        
    }
  }
  
  public func visit<T: Any>(expression: Expression.Binary) throws -> T? {
    let left = try evaluate(expression.left)
    let right = try evaluate(expression.right)
    
    switch expression.operator.type {
    case .Operator("+"):
      if left is String && right is String {
        return (left as! String) + (right as! String) as? T
      }
      if isNumber(left) && isNumber(right) {
        return try evaluateNumber(expression.operator, left, right) as? T
      }
      break
    case .Operator("-"): fallthrough
    case .Operator("/"): fallthrough
    case .Operator("*"):
      if (!isNumber(left) || !isNumber(right)) { break }
        return try evaluateNumber(expression.operator, left, right) as? T
    case .Operator(">"):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) > castNumber(right)) as? T
    case .Operator(">="):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) >= castNumber(right)) as? T
    case .Operator("<"):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) < castNumber(right)) as? T
    case .Operator("<="):
      if (!isNumber(left) || !isNumber(right)) { break }
      return (castNumber(left) <= castNumber(right)) as? T
      
    default:
      return nil
    }
    throw RoxRuntimeException.error(expression.operator, "Operands must be two numbers or two strings.")
  }
  
  public func visit<T: Any>(expression: Expression.Literal) throws -> T? {
    return expression.value as? T
  }
  
  public func visit<T: Any>(expression: Expression.Parenthesized) throws -> T? {
    return try evaluate(expression.expression) as? T
  }
  
  public func visit<T: Any>(expression: Expression.Unary) throws -> T? {
    let right = try evaluate(expression.right)
    switch expression.operator.type {
    case .Operator("-"):
      try checkNumberOperand(expression.operator, operand: right)
      if right is Double {
        return (-(right as! Double)) as? T
      } else { return (-(right as! Int)) as? T }
    case .Operator("!"):
      return !isTruthy(right) as? T
    default: break
    }
    return nil
  }

  public func evaluate(_ expression: Expression) throws -> Any {
    return try expression.accept(visitor: self)!
  }
  
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
