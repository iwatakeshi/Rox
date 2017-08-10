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
  
  public func visit<T: Any>(visitor: Expression.Binary) -> T {
    return parenthesize(visitor.token.lexeme, expressions: visitor.left, visitor.right) as! T
  }
  
  public func visit<T: Any>(visitor: Expression.Literal) -> T {
    return visitor.value == nil ? "null" as! T : String(describing: visitor.value) as! T
  }
  
  public func visit<T: Any>(visitor: Expression.Parenthesized) -> T {
    return parenthesize("group", expressions: visitor.expression) as! T
  }
  
  public func visit<T: Any>(visitor: Expression.Unary) -> T {
    return parenthesize(visitor.operator.lexeme, expressions: visitor.right) as! T
  }
  
  private func parenthesize(_ name: String, expressions: Expression...) -> String {
    var str = "(" + name
    for expression in expressions {
      str.append(" ")
      str.append(expression.accept(visitor: self) as String)
    }
    str.append(")")
    return str
  }
  
  public func print(expression: Expression) -> String {
    return expression.accept(visitor: self)
  }
}
