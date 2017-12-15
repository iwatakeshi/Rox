import Foundation

/**
 A class that represents expressions and can be evaluated
 */
public class Expression: Hashable {
  public var hashValue: Int  = 1 << 4
  
  public static func ==(lhs: Expression, rhs: Expression) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
  
  public func accept(visitor: ExpressionVisitor) throws -> Any? {
    fatalError()
  }
  
  public class Assignment: Expression {
    private(set) var name: Token
    private(set) var value: Expression
    public init(_ name: Token, _ value: Expression) {
      self.name = name
      self.value = value
      super.init()
      self.hashValue = name.lexeme.hashValue &* self.value.hashValue
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
      super.init()
      self.hashValue = left.hashValue ^ token.lexeme.hashValue ^ right.hashValue
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
      super.init()
      self.hashValue = callee.hashValue ^ parenthesis.lexeme.hashValue ^ 2574334
    }
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }

  public class Get: Expression {
    private(set) var object: Expression
    private(set) var name: Token
    public init(_ object: Expression, _ name: Token) {
      self.object = object
      self.name = name
      super.init()
      self.hashValue = object.hashValue ^ name.lexeme.hashValue
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
      super.init()
      self.hashValue = 477637 ^ 233 &* Int(arc4random())
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Literal: Expression {
    private(set) var value: Any?
    public init(_ value: Any?) {
      self.value = value
      super.init()
      self.hashValue = 673895 ^ 354 &* Int(arc4random())
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

  public class Set: Expression {
    private(set) var object: Expression
    private(set) var name: Token
    private(set) var value: Expression
    public init(_ object: Expression, _ name: Token, _ value: Expression) {
      self.object = object
      self.name = name
      self.value = value
      super.init()
      self.hashValue = object.hashValue ^ name.lexeme.hashValue ^ value
    }
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Parenthesized: Expression {
    private(set) var expression: Expression
    public init(_ expression: Expression) {
      self.expression = expression
      super.init()
      self.hashValue = expression.hashValue ^ 42900;
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Range: Expression {
    private(set) var `operator`: Token
    private(set) var right: Expression?
    private(set) var left: Expression?
    
    public init(_ left: Expression?, _ token: Token, _ right: Expression?) {
      self.left = left
      self.operator = token;
      self.right = right
      super.init()
      self.hashValue = 88300 ^ token.lexeme.hashValue ^ 479930
    }
    
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
      super.init()
      self.hashValue = (`operator`.lexeme.hashValue << 2) ^ 7455
    }
    
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
  public class Variable: Expression {
    private(set) var name: Token
    public init(_ name: Token) {
      self.name = name
      super.init()
      self.hashValue = (name.lexeme.hashValue ^ Int(arc4random())) &* 5289
    }
    public override func accept(visitor: ExpressionVisitor) throws -> Any? {
      return try visitor.visit(expression: self)
    }
  }
  
}
