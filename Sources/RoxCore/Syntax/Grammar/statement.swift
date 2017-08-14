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
    fatalError()
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
}
