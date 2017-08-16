//
//  visitor.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/9/17.
//
//

import Foundation

public protocol ExpressionVisitor {
  func visit(expression: Expression.Assignment) throws -> Any?
  func visit(expression: Expression.Binary) throws -> Any?
  func visit(expression: Expression.Call) throws -> Any?
  func visit(expression: Expression.Function) throws -> Any?
  func visit(expression: Expression.Literal) throws -> Any?
  func visit(expression: Expression.Logical) throws -> Any?
  func visit(expression: Expression.Parenthesized) throws -> Any?
  func visit(expression: Expression.Range) throws -> Any?
  func visit(expression: Expression.Unary) throws -> Any?
  func visit(expression: Expression.Variable) throws -> Any?
}

public protocol StatementVisitor {
  func visit(statement: Statement.Block) throws
  func visit(statement: Statement.Expression) throws
  func visit(statement: Statement.Function) throws
  func visit(statement: Statement.For) throws
  func visit(statement: Statement.If) throws
  func visit(statement: Statement.Print) throws
  func visit(statement: Statement.Return) throws
  func visit(statement: Statement.Variable) throws
  func visit(statement: Statement.While) throws
}
