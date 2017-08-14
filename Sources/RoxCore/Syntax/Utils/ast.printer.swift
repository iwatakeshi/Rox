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
  
  public func visit(expression: Expression.Literal) throws -> Any? {
    return String(describing: expression.value) 
  }
  
  public func visit(expression: Expression.Parenthesized) throws -> Any? {
    return try parenthesize("group", expression.expression)
  }
  
  public func visit(expression: Expression.Unary) throws -> Any? {
    return try parenthesize(expression.operator.lexeme, expression.right)
  }
  
  public func visit(expression: Expression.Variable) throws -> Any? {
    return expression.name.lexeme
  }
  
  private func parenthesize(_ name: String, _ expressions: Expression...) throws -> String {
    var str = "(" + name
    for expression in expressions {
      str.append(" ")
      str.append(try expression.accept(visitor: self) as! String)
    }
    str.append(")")
    return str
  }
  
  public func print(_ expression: Expression?) throws -> String {
    return expression != nil ? try expression!.accept(visitor: self) as! String : ""
  }
}
