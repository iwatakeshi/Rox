import Foundation

public class Expression {
  public init() {}
  
  public func accept<T>(visitor: ExpressionVisitor) -> T {
    fatalError()
  }
  
  public class Binary: Expression {
    private(set) var left: Expression
    private(set) var right: Expression
    private(set) var token: Token
    
    public init(left: Expression, token: Token, right: Expression) {
      self.left = left
      self.token = token
      self.right = right
    }
    
    public override func accept<T>(visitor: ExpressionVisitor) -> T {
      return visitor.visit(visitor: self)
    }
  }
  
  public class Parenthesized: Expression {
    private(set) var expression: Expression
    public init(expression: Expression) {
      self.expression = expression
    }
    
    public override func accept<T>(visitor: ExpressionVisitor) -> T {
      return visitor.visit(visitor: self)
    }
  }
  
  public class Literal: Expression {
    private(set) var value: Any?
    public init(value: Any?) {
      self.value = value
    }
    
    public override func accept<T>(visitor: ExpressionVisitor) -> T {
      return visitor.visit(visitor: self)
    }
    
  }
  
  public class Unary: Expression {
    private(set) var `operator`: Token
    private(set) var right: Expression
    public init(`operator`: Token, right: Expression) {
      self.operator = `operator`
      self.right = right
    }
    
    public override func accept<T>(visitor: ExpressionVisitor) -> T {
      return visitor.visit(visitor: self)
    }
  }
  
}
