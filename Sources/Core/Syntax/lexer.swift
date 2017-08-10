//
//  scanner.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation

public class Lexer {
  private(set) var tokens = [Token]()
  private(set) var source = "";
  private(set) var position: Int = 0
  private(set) var line: Int = 1
  private(set) var column: Int = 1
  private var start: Int = 0
  var isEOF : Bool {
    get { return position >= source.count || current() == Token.EOF }
  }
  
  public init(_ source: String) {
    self.source = source;
  }
  
  public func scan() -> [Token] {
    while !isEOF {
      start = position
      scanToken()
    }
    tokens.append(Token(type: .EOF, lexeme: "", literal: nil, location:
      Location(position: position + 1, line: line, column: column + 1
    )))
    return tokens
  }
  
  private func scanToken() {
    switch next() {
      case "(": addToken(.Punctuation("(")); break
      case ")": addToken(.Punctuation(")")); break
      case "{": addToken(.Punctuation("{")); break
      case "}": addToken(.Punctuation("}")); break
      case ",": addToken(.Punctuation(",")); break
      case ".": addToken(.Punctuation(".")); break
      case ";": addToken(.Punctuation(";")); break
      case "#": comment(); break
      case "-": addToken(.Operator("-")); break
      case "+": addToken(.Operator("+")); break
      case "*": addToken(.Operator("*")); break
      case "/": addToken(.Operator("/")); break
      case "!": addToken(match("=") ? .Operator("!=") : .Operator("!")); break
      case "=": addToken(match("=") ? .Operator("==") : .Operator("=")); break
      case "<": addToken(match("=") ? .Operator("<=") : .Operator("<")); break
      case ">": addToken(match("=") ? .Operator(">=") : .Operator(">")); break
      case "\"": string(); break
      case " ": fallthrough
      case "\r": fallthrough
      case "\t": fallthrough
      case "\n": break
      case _ where isDigit(previous()): number()
      case _ where isAlpha(previous()): identifier()
      default: print("[error]: Unrecongnized character \(previous())");
    }
  }
  
  private func current() -> String {
   return peek()
  }

  @discardableResult private func next() -> String {
    if (current() == "\n") {
      line = line + 1
      column = 1
    } else {
      column = column + 1
    }
    position = position + 1
    return position - 1 >= source.count ? Token.EOF : source[position - 1]
  }
  
  private func previous() -> String {
    return peek(to: -1)
  }
  
  private func peek(to: Int = 0) -> String {
    if to < 0 && position + to < 0 { return Token.EOF }
    else if to + position > source.count { return Token.EOF }
    return position + to >= 0 ? source[position + to] : Token.EOF
  }
  
  private func addToken(_ type: TokenType) {
    addToken(type, literal: nil)
  }
  
  private func addToken(_ type: TokenType, literal: Any?) {
    addToken(type, lexeme: String(describing: literal), literal: literal)
  }
  
  private func addToken(_ type: TokenType, lexeme: String, literal: Any?) {
    tokens.append(Token(
      type: type, lexeme: source[start..<position], literal: literal, location:
      Location(
        position: position, line: line, column: column
      )))
  }
  
  private func match(_ expected: String) -> Bool {
    if isEOF { return false }
    if current() != expected { return false }
    next()
    return true
  }
  
  private func isAlpha(_ ch: String) -> Bool {
    let c = ch.toArray()[0]
    return
      (c >= "a" && c <= "z") ||
      (c >= "A" && c <= "Z") ||
      c == "_" || c == "$"
  }
  
  private func isDigit(_ ch: String) -> Bool {
    let c = ch.toArray()[0]
    return  c >= "0" && c <= "9"
  }
  
  private func isAlphaNumeric(_ ch: String) -> Bool {
    return isAlpha(ch) || isDigit(ch)
  }
  
  /* Scanners */
  
  private func comment() {
    if previous() == "#" {
      while current() != "\n" && !isEOF { next() }
    }
    if previous() == "/" && current() == "*" {
      
    }
  }
  
  private func string() {
    let ch = previous()
    while current() != ch && !isEOF { next() }
    
    if isEOF {
      print("[error]: Unterminated string")
      return
    }
    
    next()
    let value = source[(start + 1)..<(position - 1)]
    addToken(.StringLiteral, literal: value)
  }
  
  private func number() {
    while isDigit(current()) { next() }
    if current() == "." && isDigit(peek(to: 1)) {
      next()
      while(isDigit(current())) { next () }
    }
    addToken(.NumberLiteral, literal: Double(source[start..<position]))
  }
  
  private func identifier() {
    while isAlphaNumeric(current()) { next() }
    
    let lexeme = source[start..<position]
    
    var type: TokenType = .Identifier;
    if Token.isReserved(lexeme) { type = .Reserved(lexeme) }
    if Token.isOperator(lexeme) { type = .Operator(lexeme) }
    addToken(type)
  }
  
}
