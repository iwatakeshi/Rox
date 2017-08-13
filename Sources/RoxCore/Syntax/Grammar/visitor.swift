//
//  visitor.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/9/17.
//
//

import Foundation

public protocol ExpressionVisitor {
  func visit(expression: Expression.Binary) throws -> Any?
  func visit(expression: Expression.Literal) throws -> Any?
  func visit(expression: Expression.Parenthesized) throws -> Any?
  func visit(expression: Expression.Unary) throws -> Any?
}

public protocol StatementVisitor {
  func visit(statement: Statement.Expression) throws
  func visit(statement: Statement.Print) throws
}
