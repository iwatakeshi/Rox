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
      return try visitor.visit(expression: self)!
    }
  }
  
  public class Parenthesized: Expression {
    private(set) var expression: Expression
    public init(_ expression: Expression) {
      self.expression = expression
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)!
    }
  }
  
  public class Literal: Expression {
    private(set) var value: Any
    public init(_ value: Any?) {
      self.value = value == nil ? "null" : value!
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)!
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
      return try visitor.visit(expression: self)!
    }
  }
  
  public class Variable: Expression {
    private(set) var name: Token
    public init(_ name: Token) {
      self.name = name
    }
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)!
    }
  }
  
}