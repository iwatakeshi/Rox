//
//  main.swift
//  rox
//
//  Created by Takeshi Iwana on 8/8/17.
//  Copyright © 2017 Takeshi Iwana. All rights reserved.
//

import Foundation
import Core

private func read(path: String) -> String {
  let file = URL(fileURLWithPath: path)
  do {
    let source = try String(contentsOf: file)
    return source
  } catch {
    return ""
  }
}

// private func parenthesized(_ center: Expression) -> Expression.Parenthesized {
//   return Expression.Parenthesized(expression: center)
// }

// private func binary(_ left: Expression, _ token: Token, _ right: Expression) -> Expression.Binary {
//   return Expression.Binary(left: left, token: token, right: right)
// }

// private func unary(_ `operator`: Token, right: Expression) -> Expression.Unary {
//   return Expression.Unary(operator: `operator`, right: right)
// }

// private func token(_ type: TokenType, _ lexeme: String, _ literal: Any?) -> Token {
//   return Token(type: type, lexeme: lexeme, literal: literal, location: Location(position: 0, line: 0, column: 0))
// }

// private func literal(_ value: Any?) -> Expression.Literal {
//   return Expression.Literal(value: value)
// }

// let left = unary(token(.Operator("-"), "-", nil), right: literal(123))
// let op = token(.Operator("*"), "*", nil)
// let right = parenthesized(literal(45.67))

//let expression = Expression.Unary
// let expression = binary(left, op, right)



let arguments = CommandLine.arguments

if arguments.count > 2 {
  print("Usage: rox [script]")
} else if arguments.count == 2 {
  Rox.run(source: read(path: arguments[0]))
} else {
  Rox.repl()
}
