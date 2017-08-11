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
  private var startLocation = Location()
  private var endLocation: Location {
    get { return Location(position, line, column) }
  }
  var isEOF : Bool {
    get { return position >= source.count || current() == Token.EOF }
  }
  
  public init() { }
  
  public init(_ source: String) {
    self.source = source
  }
  
  public func scan(_ source: String) -> [Token] {
    self.source = source
    self.position = 0
    self.line = 0
    self.column = 1
    self.tokens = [Token]()
    return scan()
  }
  
  public func scan() -> [Token] {
    while !isEOF {
      start = position
      startLocation = Location(position, line, column)
      scanToken()
    }
    tokens.append(Token(.EOF, "", nil, startLocation))
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
      case "#": ScanComment(); break
      case "-": addToken(.Operator("-")); break
      case "+": addToken(.Operator("+")); break
      case "*": addToken(.Operator("*")); break
      case "/": addToken(.Operator("/")); break
      case "!": addToken(match("=") ? .Operator("!=") : .Operator("!")); break
      case "=": addToken(match("=") ? .Operator("==") : .Operator("=")); break
      case "<": addToken(match("=") ? .Operator("<=") : .Operator("<")); break
      case ">": addToken(match("=") ? .Operator(">=") : .Operator(">")); break
      case "\"": scanString(); break
      case " ": fallthrough
      case "\r": fallthrough
      case "\t": fallthrough
      case "\n": break
      case _ where isDigit(previous()): ScanNumber()
      case _ where isAlpha(previous()): scanIdentifier()
      default: Rox.error(startLocation, "Unexpcted character '\(previous())'")
    }
  }
  
  private func current() -> String {
   return peek()
  }

  @discardableResult
  private func next() -> String {
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
    tokens.append(Token( type, source[start..<position], literal, startLocation))
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
  
  private func ScanComment() {
    if previous() == "#" {
      while current() != "\n" && !isEOF { next() }
    }
    if previous() == "/" && current() == "*" {
      
    }
  }
  
  private func scanString() {
    let ch = previous()
    while current() != ch && !isEOF { next() }
    
    if isEOF {
      Rox.error(endLocation, "Unterminated string")
      return
    }
    
    next()
    let value = source[(start + 1)..<(position - 1)]
    addToken(.StringLiteral, literal: value)
  }
  
  private func ScanNumber() {
    while isDigit(current()) { next() }
    if current() == "." && isDigit(peek(to: 1)) {
      next()
      while(isDigit(current())) { next () }
    }
    let number = source[start..<position];
    addToken(.NumberLiteral, literal: number.contains(".") ? Double(number) : Int(number))
  }
  
  private func scanIdentifier() {
    while isAlphaNumeric(current()) { next() }
    
    let lexeme = source[start..<position]
    
    var type: TokenType = .Identifier;
    if Token.isReserved(lexeme) { type = .Reserved(lexeme) }
    if Token.isOperator(lexeme) { type = .Operator(lexeme) }
    addToken(type)
  }
  
}
