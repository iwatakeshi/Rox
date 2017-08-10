//
//  visitor.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/9/17.
//
//

import Foundation

public protocol ExpressionVisitor {
  func visit<T: Any>(visitor: Expression.Binary) -> T
  func visit<T: Any>(visitor: Expression.Literal) -> T
  func visit<T: Any>(visitor: Expression.Parenthesized) -> T
  func visit<T: Any>(visitor: Expression.Unary) -> T
}
