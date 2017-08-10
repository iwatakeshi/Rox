import Foundation

class Parser {
  private var tokens: [Token];
  private var position: Int = 0
  private var isEOF: Bool {
    get { return tokens[position].type == .EOF }
  }

  public init(_ tokens: [Token]) {
    self.tokens = tokens
  }
  
  public func parse() -> Expression? {
    do {
      return try parseExpression()
    } catch {
      return nil
    }
  }

  /* Expressions */

  private func parseExpression() throws -> Expression {
    return try parseEquality()
  }

  private func parseEquality() throws -> Expression {
    var expression = try parseComparison()
    while match(.Operator("!="), .Operator("==")) {
      let `operator` = previous()
      let right = try parseComparison()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }

  private func parseComparison() throws -> Expression {
    var expression = try parseAddition()
    while match(.Operator(">"), .Operator(">="), .Operator("<"), .Operator("<=")) {
      let `operator` = previous()
      let right = try parseAddition()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }

  private func parseAddition() throws -> Expression {
    var expression = try parseMultiplication()

    while match(.Operator("-"), .Operator("+")) {
      let `operator` = previous()
      let right = try parseMultiplication()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }

  private func parseMultiplication() throws -> Expression {
    var expression = try parseUnary()
    while match(.Operator("/"), .Operator("*")) {
      let `operator` = previous()
      let right = try parseMultiplication()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }

  private func parseUnary() throws -> Expression {
    if match(.Operator("-"), .Operator("!")) {
      let `operator` = previous()
      let right = try parseUnary()
      return Expression.Unary(`operator`, right)
    }
    return try parsePrimary()
  }

  private func parsePrimary() throws -> Expression {
    if match(.Reserved("true")) { return Expression.Literal(true) }
    if match(.Reserved("false")) { return Expression.Literal(false) }
    if match(.Reserved("null")) { return Expression.Literal(nil) }
    
    if match(.NumberLiteral, .StringLiteral) {
      return Expression.Literal(previous().literal)
    }

    if match(.Punctuation("(")) {
      let expression = try parseExpression()
      try consume(.Punctuation(")"), "Expect ')' after expression")
      return Expression.Parenthesized(expression)
    }

    throw error(previous(), "Expect expression.")
  }

  /* Helper methods */

  private func match(_ types: TokenType...) -> Bool {
    for type in types {
      if check(type) {
        next()
        return true
      }
    }
    return false
  }

  private func check(_ type: TokenType) -> Bool {
    if isEOF { return false }
    return current().type == type
  }
  
  private func current() -> Token {
    return tokens[position]
  }

  @discardableResult
  private func next() -> Token {
    if !isEOF { position = position + 1 }
    return previous()
  }

  private func previous () -> Token {
    return position > 0 ? tokens[position - 1] : tokens[position]
  }

  @discardableResult
  private func consume(_ type: TokenType, _ message: String) throws -> Token {
    if check(type) { return next() }
    throw error(current(), message)
  }

  private func error(_ token: Token, _ message: String) -> ParserException {
    Rox.error(token.location, message)
    return ParserException.parse
  }

  private func synchronize() {
    next()
    while !isEOF {
      if previous().type == .Punctuation(";") { return }
      switch current().type {
      case .Reserved("class"): fallthrough
      case .Reserved("func"): fallthrough
      case .Reserved("var"): fallthrough
      case .Reserved("for"): fallthrough
      case .Reserved("if"): fallthrough
      case .Reserved("while"): fallthrough
      case .Reserved("print"): fallthrough
      case .Reserved("return"): return
      default: break
      }
      next()
    }
  }
}
