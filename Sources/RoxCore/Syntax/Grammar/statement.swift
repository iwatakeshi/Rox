//
//  statement.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/12/17.
//
//

import Foundation

public class Statement {
  
  public func accept(visitor: StatementVisitor) throws {
    preconditionFailure("The method or operation is not implemented.")
  }
  
  public class Block: Statement {
    private(set) var statements: [Statement]
    public init(_ statements: [Statement]) {
      self.statements = statements
    }
    
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }
  
  public class Expression : Statement {
    private(set) var expression: RoxCore.Expression
    public init(_ expression: RoxCore.Expression) {
        self.expression = expression
    }
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }

  public class For: Statement {
    private(set) var name: Token?
    private(set) var index: Token?
    private(set) var expression: RoxCore.Expression
    private(set) var body: Statement
    public init(_ name: Token?, _ index: Token?, _ expression: RoxCore.Expression, _ body: Statement) {
      self.name = name
      self.index = index
      self.expression = expression
      self.body = body
    }
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }

  public class Function: Statement {
    private(set) var name: Token
    private(set) var parameters: [Token]
    private(set) var body: [Statement]
    
    public init(_ name: Token, _ parameters: [Token], _ body: [Statement]) {
      self.name = name
      self.parameters = parameters
      self.body = body
    }
    
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }
  
  public class If: Statement {
    private(set) var condition: RoxCore.Expression
    private(set) var then: Statement
    private(set) var `else`: Statement?
    public init(_ condition: RoxCore.Expression, _ then: Statement, _ `else`: Statement?) {
      self.condition = condition
      self.then = then
      self.else = `else`
    }
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }
  
  public class Print: Statement {
    private(set) var expression: RoxCore.Expression
    public init(_ expression: RoxCore.Expression) {
      self.expression = expression
    }
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }

  public class Variable: Statement {
    private(set) var name: Token
    private(set) var value: RoxCore.Expression?
    public init(_ name: Token, _ value: RoxCore.Expression?) {
      self.name = name
      self.value = value
    }
    
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }
  
  public class While: Statement {
    private(set) var condition: RoxCore.Expression
    private(set) var body: Statement
    public init(_ condition: RoxCore.Expression, _ body: Statement) {
      self.condition = condition
      self.body = body
    }
    public override func accept(visitor: StatementVisitor) throws {
      try visitor.visit(statement: self)
    }
  }
}
