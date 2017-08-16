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
        break
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
          let last = statements[statements.count - 1]
          if foundExpression {
            return (last as! Statement.Expression).expression
          } else if last is Statement.Expression {
            return (last as! Statement.Expression).expression
          }
        } catch {
          break
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
    return try parseAssignmentExpression()
  }

  private func parseAssignmentExpression() throws -> Expression {
    let expression = try parseOrExpression()

    if match(.Operator("=")) {
      let equals = previous()
      let value = try parseAssignmentExpression()
      
      if expression is Expression.Variable {
        let name = (expression as! Expression.Variable).name
        return Expression.Assignment(name, value)
      }
      throw error(equals, "Invalid assignment target")
    }
    return expression
  }
  
  private func parseOrExpression() throws -> Expression {
    var expression = try parseAndExpression()
    while match(.Operator("or")) {
      let `operator` = previous()
      let right = try parseAndExpression()
      expression = Expression.Logical(expression, `operator`, right)
    }
    return expression
  }
  
  private func parseAndExpression() throws -> Expression {
    var expression = try parseEqualityExpression()
    while match(.Operator("and")) {
      let `operator` = previous()
      let right = try parseEqualityExpression()
      expression = Expression.Logical(expression, `operator`, right)
    }
    return expression
  }
  
  private func parseEqualityExpression() throws -> Expression {
    var expression = try parseRangeExpression()
    while match(.Operator("!="), .Operator("==")) {
      let `operator` = previous()
      let right = try parseRangeExpression()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }
  
  private func parseRangeExpression() throws -> Expression {
    let expression = try parseAdditionExpression()
    if match(.Operator("..")) {
      let `operator` = previous()
      let right = try parseAdditionExpression()
      return Expression.Range(expression, `operator`, right)
    }
    return expression
  }
  
  private func parseComparisonExpression() throws -> Expression {
    var expression = try parseAdditionExpression()
    while match(.Operator(">"), .Operator(">="), .Operator("<"), .Operator("<=")) {
      let `operator` = previous()
      let right = try parseAdditionExpression()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }

  private func parseAdditionExpression() throws -> Expression {
    var expression = try parseMultiplicationExpression()

    while match(.Operator("-"), .Operator("+")) {
      let `operator` = previous()
      let right = try parseMultiplicationExpression()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }

  private func parseMultiplicationExpression() throws -> Expression {
    var expression = try parseUnaryExpression()
    while match(.Operator("/"), .Operator("*")) {
      let `operator` = previous()
      let right = try parseMultiplicationExpression()
      expression = Expression.Binary(expression, `operator`, right)
    }
    return expression
  }

  private func parseUnaryExpression() throws -> Expression {
    if match(.Operator("-"), .Operator("!")) {
      let `operator` = previous()
      let right = try parseUnaryExpression()
      return Expression.Unary(`operator`, right)
    }
    return try parseCallExpression()
  }
  
  private func parseCallExpression() throws -> Expression {
    var expression = try parsePrimaryExpression()
    
    while true {
      if match(.Punctuation("(")) {
        expression = try finishCall(expression)
      }  else { break }
    }
    return expression
  }

  private func parsePrimaryExpression() throws -> Expression {
    if match(.Reserved("true")) { return Expression.Literal(true) }
    if match(.Reserved("false")) { return Expression.Literal(false) }
    if match(.Reserved("null")) { return Expression.Literal(nil) }
    
    if match(.Reserved("func")) { return try parseFunctionBody("function") }
    
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
  
  private func parseDeclarationStatement() throws -> Statement {
    do {
      if check(.Reserved("func")) && check(.Identifier, 1) {
        try consume(.Reserved("func"), "")
        return try parseFunctionStatement("function")
      }
      if match(.Reserved("var")) { return try parseVariableStatement() }
    } catch RoxException.RoxParserException(.error(_, _)) {
      synchronize()
    }
    return try parseStatement()
  }
  
  private func parseStatement() throws -> Statement {
    do {
      if match(.Punctuation("{")) { return try Statement.Block(parseBlockStatement()) }
      if match(.Reserved("for")) { return try parseForStatement() }
      if match(.Reserved("if")) { return try parseIfStatement() }
      if match(.Reserved("print")) { return try parsePrintStatement() }
      if match(.Reserved("return")) { return try parseReturnStatement() }
      if match(.Reserved("while")) { return try parseWhileStatement() }
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
    }
    try consume(.Punctuation(";"), "Expect ';' after expression", false)
    return Statement.Expression(value)
  }
  
  private func parseFunctionStatement(_ kind: String) throws -> Statement.Function {
    let name: Token = try consume(.Identifier, "Expect identifier after \(kind) name")
    let function = try parseFunctionBody(kind)
    return Statement.Function(name, function)
  }
  
  private func parseForStatement() throws -> Statement {
    var name: Token?
    var index: Token?
    if match(.Punctuation("(")) {
      name = try consume(.Identifier, "Expect identifier after '('")
      if match(.Punctuation(",")) { index = try consume(.Identifier, "Expect indentifier after ','") }
      try consume(.Punctuation(")"), "Expect ')' after identifier");
    } else { name = try consume(.Identifier, "Expect identifier after 'for'") }
    
    try consume(.Operator("in"), "Expect 'in' after \(index == nil ? "identifier" : "')'")")
    let expression = try parseExpression()
    
    return Statement.For(name, index, expression, try parseStatement())
  }
  
  private func parseIfStatement() throws -> Statement {
    try consume(.Punctuation("("), "Expect '(' after 'if'", false)
    let condition = try parseExpression()
    try consume(.Punctuation(")"), "Expect ')' after condition", false)
    let then = try parseStatement()
    var `else`: Statement?
    if match(.Reserved("else")) {
      `else` = try parseStatement()
    }
    
    return Statement.If(condition, then, `else`)
  }
  
  private func parsePrintStatement() throws -> Statement {
    let value = try parseExpression()
    try consume(.Punctuation(";"), "Expect ';' after expression", false)
    return Statement.Print(value)
  }
  
  private func parseReturnStatement() throws -> Statement {
    let keyword = previous()
    var value: Expression?
    if match(.Punctuation(";")) {}
    value = try parseExpression()
    return Statement.Return(keyword, value)
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
  
  public func parseWhileStatement() throws -> Statement {
    try consume(.Punctuation("("), "Expect '(' after 'while'", false)
    let condition = try parseExpression()
    try consume(.Punctuation(")"), "Expect ')' after condition", false)
    return Statement.While(condition, try parseStatement())
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
  
  private func check(_ type: TokenType, _ by: Int) -> Bool {
    if (position + by >= tokens.count) { return false }
    if (tokens[position + by].type == .EOF) { return false }
    return tokens[position + by].type == type
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
    if !required { return check(type) ? next() : current() }
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
  
  private func finishCall(_ callee: Expression) throws -> Expression {
    var arguments = [Expression]()
    if (!check(.Punctuation(")"))) {
      repeat {
        arguments.append(try parseExpression())
      } while match(.Punctuation(","))
    }
    let parenthesis = try consume(.Punctuation(")"), "Expect ')' after arguments")
    return Expression.Call(callee, parenthesis, arguments)
  }
  
  private func parseFunctionBody(_ kind: String) throws -> Expression.Function {
    var parameters = [Token]()
    try consume(.Punctuation("("), "Expect '(' after \(kind) name")
    if !check(.Punctuation(")")) {
      repeat {
        parameters.append(try consume(.Identifier, "Expect parameter name"))
      } while match(.Punctuation(","))
    }
    try consume(.Punctuation(")"), "Expect ')' after parameters")
    
    try consume(.Punctuation("{"), "Expect '{' before \(kind) body")
    
    let body = try parseBlockStatement()
    return Expression.Function(parameters, body)
  }
}
