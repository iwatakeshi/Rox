//
//  token.ext.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/9/17.
//
//

import Foundation

extension TokenType : Equatable {
  
  static public func ==(left: TokenType, right: TokenType) -> Bool {
    switch (left, right) {
    case (.StringLiteral, .StringLiteral): return true
    case (.NumberLiteral, .NumberLiteral): return true
    case (.BooleanLiteral, .BooleanLiteral): return true
    case (.NullLiteral, .NullLiteral): return true
    case (.Identifier, .Identifier): return true
    case (.Reserved(let a), .Reserved(let b)): return a == b
    case (.Operator(let a), .Operator(let b)): return a == b
    case (.Punctuation(let a), .Punctuation(let b)): return a == b
    case (.Invalid, .Invalid): return true
    case (.EOF, .EOF): return true
    default:
      return false
    }
  }
}

extension Token : Equatable {
  public static func == (left: Token, right: Token) -> Bool {
    return left.type == right.type && left.lexeme == right.lexeme
  }
  public static func ===(left: Token, right: Token) -> Bool {
    return left.type == right.type && left.location == right.location;
  }
}
