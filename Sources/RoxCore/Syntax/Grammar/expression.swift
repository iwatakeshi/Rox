import Foundation

/**
 A class that represents expressions and can be evaluated
 */
public class Expression {
  public init() {}
  
  public func accept(visitor: ExpressionVisitor) throws -> Any? {
    fatalError()
  }
  public class Assignment: Expression {
    private(set) var name: Token
    private(set) var value: Expression
    public init(_ name: Token, _ value: Expression) {
      self.name = name
      self.value = value
    }
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  public class Binary: Expression {
    private(set) var left: Expression
    private(set) var right: Expression
    private(set) var `operator`: Token
    
    public init(_ left: Expression, _ token: Token, _ right: Expression) {
      self.left = left
      self.operator = token
      self.right = right
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Call : Expression {
    private(set) var callee: Expression
    private(set) var parenthesis: Token
    private(set) var arguments: [Expression]
    public init(_ callee: Expression, _ parenthesis: Token, _ arguments: [Expression]) {
      self.callee = callee
      self.parenthesis = parenthesis
      self.arguments = arguments
    }
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Function : Expression {
    private(set) var parameters: [Token]
    private(set) var body: [RoxCore.Statement] = []
    public init(_ parameters: [Token], _ body: [RoxCore.Statement]) {
      self.parameters = parameters
      self.body = body
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Literal: Expression {
    private(set) var value: Any?
    public init(_ value: Any?) {
      self.value = value
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
    
  }
  
  public class Logical: Binary {
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Parenthesized: Expression {
    private(set) var expression: Expression
    public init(_ expression: Expression) {
      self.expression = expression
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Range: Binary {
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Unary: Expression {
    private(set) var `operator`: Token
    private(set) var right: Expression
    public init(_ `operator`: Token, _ right: Expression) {
      self.operator = `operator`
      self.right = right
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Variable: Expression {
    private(set) var name: Token
    public init(_ name: Token) {
      self.name = name
    }
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
}
