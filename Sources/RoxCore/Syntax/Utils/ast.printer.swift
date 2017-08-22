//
//  ast.printer.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/9/17.
//
//

import Foundation

public class ASTPrinter: ExpressionVisitor {

  
  public init() {}
  
  public func visit(expression: Expression.Assignment) throws -> Any? {
    return try parenthesize("=", expression, expression.value)
  }
  
  public func visit(expression: Expression.Binary) throws -> Any? {
    return try parenthesize(expression.operator.lexeme, expression.left, expression.right)
  }
  
  public func visit(expression: Expression.Call) throws -> Any? {
    return ""
  }
  
  public func visit(expression: Expression.Function) throws -> Any? {
    return "(lambda (arity \(expression.parameters.count)))"
  }
  
  public func visit(expression: Expression.Literal) throws -> Any? {
    return expression.value
  }
  public func visit(expression: Expression.Logical) throws -> Any? {
    return try parenthesize(expression.operator.lexeme, expression.left, expression.right)
  }
  
  public func visit(expression: Expression.Parenthesized) throws -> Any? {
    return try parenthesize("group", expression.expression)
  }
  
  public func visit(expression: Expression.Range) throws -> Any? {
    return try parenthesize(expression.operator.lexeme, expression.left, expression.right)
  }
  
  public func visit(expression: Expression.Unary) throws -> Any? {
    return try parenthesize(expression.operator.lexeme, expression.right)
  }
  
  public func visit(expression: Expression.Variable) throws -> Any? {
    return expression.name.lexeme
  }
  
  private func parenthesize(_ name: String, _ expressions: Expression?...) throws -> String {
    var str = "(" + name
    for expression in expressions {
      str.append(" ")
      str.append(expression == nil ? "0" : castString(try expression?.accept(visitor: self)))
    }
    str.append(")")
    return str
  }
  
  public func print(_ expression: Expression?) throws -> String {
    return expression != nil ? castString(try expression!.accept(visitor: self)) : ""
  }
  
  public func castString(_ value: Any?) -> String {
    if value == nil { return "null" }
    if value is String { return value as! String }
    if value is Int { return "\(value as! Int)" }
    if value is Double { return "\(value as! Double)" }
    if value is Bool { return "\(value as! Bool)" }
    return ""
  }
}
