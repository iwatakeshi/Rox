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
  
  public func visit<T: Any>(expression: Expression.Binary) throws -> T {
    return try parenthesize(expression.operator.lexeme, expressions: expression.left, expression.right) as! T
  }
  
  public func visit<T: Any>(expression: Expression.Literal) throws -> T {
    return String(describing: expression.value) as! T
  }
  
  public func visit<T: Any>(expression: Expression.Parenthesized) throws -> T {
    return try parenthesize("group", expressions: expression.expression) as! T
  }
  
  public func visit<T: Any>(expression: Expression.Unary) throws -> T {
    return try parenthesize(expression.operator.lexeme, expressions: expression.right) as! T
  }
  
  private func parenthesize(_ name: String, expressions: Expression...) throws -> String {
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
