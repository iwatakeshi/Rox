import Foundation

/**
 A class responsible of parsing a sequence of tokens and
 determining whether the sequence is in the grammar.
 */
public class Parser {
  private var tokens: [Token];
  private var position: Int = 0
  private var allowExpression = false
  private var foundExpression = false
  private var isEOF: Bool {
    get { return tokens[position].type == .EOF }
  }
  
  public enum ParseType {
    case Expression
    case Statement
  }
  
  public init() {
    self.tokens = [Token]()
  }
  
  public init(_ tokens: [Token]) {
    self.tokens = tokens
  }
  
  
  public func parse(_ tokens: [Token], type: ParseType) -> Any? {
    self.tokens = tokens
    self.position = 0
    switch type {
    case .Expression:
      do {
        return try parseExpression()
      } catch {
        return nil
      }
    default: return parse()
    }
  }
  
  /**
   Parses the tokens and generates a parse tree
   
   - Returns: The parse tree
   */
  public func parse() -> [Statement] {
    var statements = [Statement]()
    while !isEOF {
      do {
        statements.append(try parseDeclarationStatement())
      } catch {
      }
    }
    return statements
  }
  
public func parseRepl() -> Any? {
  var statements = [Statement]()
    allowExpression = true
    while !isEOF {
      do {
        statements.append(try parseDeclarationStatement())
        if foundExpression {
          let last = statements[statements.count - 1]
          return (last as! Statement.Expression).expression
        }
      } catch {
      }
      allowExpression = false
    }
    return statements
}

  /**
   Parses the given tokens and generates a parse tree
   
   - Returns: The parse tree
   */
  public func parse(_ tokens: [Token]) -> [Statement] {
    self.tokens = tokens
    self.position = 0
    return parse()
  }

  /* Expressions */

  private func parseExpression() throws -> Expression {
    return try parseAssignment()
  }

  private func parseAssignment() throws -> Expression {
    let expression = try parseEquality()

    if match(.Operator("=")) {
      let equals = previous()
      let value = try parseAssignment()
      
      if expression is Expression.Variable {
        let name = (expression as! Expression.Variable).name
        return Expression.Assignment(name, value)
      }
      throw error(equals, "Invalid assignment target")
    }
    return expression
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
    
    if match(.Identifier) { return Expression.Variable(previous()) }
    
    if match(.Punctuation("(")) {
      let expression = try parseExpression()
      try consume(.Punctuation(")"), "Expect ')' after expression")
      return Expression.Parenthesized(expression)
    }

    throw error(previous(), "Expect expression")
  }

  /* Statements */
  
  private func parseStatement() throws -> Statement {
    do {
      if match(.Reserved("print")) { return try parsePrintStatement() }
      if match(.Punctuation("{")) { return try Statement.Block(parseBlockStatement()) }
      return try parseExpressionStatement()
    } catch RoxException.RoxParserException(.error(_, _)) {

    }
    return try parseExpressionStatement()
  }
  
  private func parseBlockStatement() throws -> [Statement] {
    var statements = [Statement]()
    while !check(.Punctuation("}")) && !isEOF {
      statements.append(try parseDeclarationStatement())
    }
    try consume(.Punctuation("}"), "Expect '}' after block")
    return statements
  }
  
  private func parseExpressionStatement() throws -> Statement {
    let value = try parseExpression()
    if allowExpression && isEOF {
      foundExpression = true
    } else {
      try consume(.Punctuation(";"), "Expect ';' after expression", false)
    }
    return Statement.Expression(value)
  }
  
  private func parsePrintStatement() throws -> Statement {
    let value = try parseExpression()
    try consume(.Punctuation(";"), "Expect ';' after expression", false)
    return Statement.Print(value)
  }
  
  private func parseDeclarationStatement() throws -> Statement {
    do {
      if match(.Reserved("var")) { return try parseVariableStatement() }
    } catch RoxException.RoxParserException(.error(_, _)) {
      synchronize()
    }
    return try parseStatement()
  }
  
  public func parseVariableStatement() throws -> Statement {
    let name = try consume(.Identifier, "Expect identifier after 'var' declaration")
    var value: Expression?
    
    if match(.Operator("=")) {
      value = try parseExpression()
    }
    try consume(.Punctuation(";"), "Expect ';' after variable declaration", false)
    return Statement.Variable(name, value)
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
  private func consume(_ type: TokenType, _ message: String, _ required: Bool = true) throws -> Token {
    if !required { return current() }
    if check(type) { return next() }
    throw error(current(), message)
  }

  private func error(_ token: Token, _ message: String) -> RoxParserException {
    let exception = RoxParserException.error(token, message)
    Rox.error(.RoxParserException(exception))
    return exception
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
