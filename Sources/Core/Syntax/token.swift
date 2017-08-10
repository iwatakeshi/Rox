//
//  File.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation

public enum TokenType {
  /* Literals */
  // "Hello, World!" or 'Hello, World!'
  case StringLiteral
  // 12
  case NumberLiteral
  // true
  case BooleanLiteral
  // null
  case NullLiteral

  /* Identifier */
  case Identifier

  /* Reserved */
  case Reserved(String)

  /* Operator */
  case Operator(String)

  /* Punctuations */
  // '(':
  case Punctuation(String)

  /* Others */
  case Invalid
  case EOF
}


public struct Token {
  private(set) var type: TokenType
  private(set) var lexeme: String
  private(set) var literal: Any?
  private(set) var location: Location
  static private(set) var EOF : String = "\0"
  
  public init(_ type: TokenType, _ lexeme: String, _ literal: Any?, _ location: Location) {
    self.type = type
    self.lexeme = lexeme
    self.literal = literal
    self.location = location
  }
  
  public static func isReserved(_ lexeme: String) -> Bool {
    switch lexeme {
    case "and": fallthrough
    case "class": fallthrough
    case "else": fallthrough
    case "false": fallthrough
    case "for": fallthrough
    case "func": fallthrough
    case "if": fallthrough
    case "null": fallthrough
    case "or": fallthrough
    case "print": fallthrough
    case "return": fallthrough
    case "super": fallthrough
    case "this": fallthrough
    case "true": fallthrough
    case "var": fallthrough
    case "while": return true
    default: return false;
    }
  }
    
  public static func isOperator(_ lexeme: String) -> Bool {
    switch lexeme {
    case "and": fallthrough
    case "or": fallthrough
    case "+": fallthrough
    case "-": fallthrough
    case "*": fallthrough
    case "/": fallthrough
    case "=": fallthrough
    case "!": fallthrough
    case "==": fallthrough
    case "!=": fallthrough
    case "<" : fallthrough
    case "<=": fallthrough
    case ">": fallthrough
    case ">=": return true
    default: return false
    }
  }
  
}
