//
//  visitor.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/9/17.
//
//

import Foundation

public protocol ExpressionVisitor {
  func visit<T: Any>(visitor: Expression.Binary) throws -> T?
  func visit<T: Any>(visitor: Expression.Literal) throws -> T?
  func visit<T: Any>(visitor: Expression.Parenthesized) throws -> T?
  func visit<T: Any>(visitor: Expression.Unary) throws -> T?
}
