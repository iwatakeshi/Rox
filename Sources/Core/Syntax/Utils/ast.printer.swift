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
  
  public func visit<T: Any>(visitor: Expression.Binary) throws -> T {
    return try parenthesize(visitor.operator.lexeme, expressions: visitor.left, visitor.right) as! T
  }
  
  public func visit<T: Any>(visitor: Expression.Literal) throws -> T {
    return String(describing: visitor.value) as! T
  }
  
  public func visit<T: Any>(visitor: Expression.Parenthesized) throws -> T {
    return try parenthesize("group", expressions: visitor.expression) as! T
  }
  
  public func visit<T: Any>(visitor: Expression.Unary) throws -> T {
    return try parenthesize(visitor.operator.lexeme, expressions: visitor.right) as! T
  }
  
  private func parenthesize(_ name: String, expressions: Expression...) throws -> String {
    var str = "(" + name
    for expression in expressions {
      str.append(" ")
      str.append(try expression.accept(visitor: self) as String)
    }
    str.append(")")
    return str
  }
  
  public func print(_ expression: Expression?) throws -> String {
    return expression != nil ? try expression!.accept(visitor: self) : ""
  }
}
