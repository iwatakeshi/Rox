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
  case Punctuation(String)

  /* Others */
  case Invalid
  case EOF
}

/// A structure representing a lexeme
public struct Token {
  /// Token type
  private(set) var type: TokenType
  /// Token lexeme
  private(set) var lexeme: String
  /// Token literal value
  private(set) var literal: Any?
  /// Token location
  private(set) var location: Location
  /// The end-of-file string
  static private(set) var EOF : String = "\0"
  /**
   Initializes a new token
   
   - Parameters:
   - type: The token type
   - lexeme: The scanned lexeme
   - literal: The scanned literal value
   
   - Returns: An instance of Token
   */
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
    case "in": fallthrough
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
    case "in": fallthrough
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
