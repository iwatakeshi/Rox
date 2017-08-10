import XCTest
import Core

class RoxTests: XCTestCase {
  
  private func create(_ type: TokenType, _ lexeme: String, _ literal: Any?, _ location: Location) -> Token {
    return Token(type: type, lexeme: lexeme, literal: literal, location: location)
  }
  
  private func createEOF(_ location: Location) -> Token {
    return Token(type: .EOF, lexeme: "", literal: nil, location: location)
  }
  
  func testHelloWorld() {
    XCTAssertEqual(Lexer("Hello World!").scan(), [
      create(.Identifier, "Hello", "Hello", Location(position: 5, line: 1, column: 6)),
      create(.Identifier, "World", "World", Location(position: 11, line: 1, column: 12)),
      create(.Operator("!"), "!", nil, Location(position: 12, line: 1, column: 13)),
      createEOF(Location(position: 13, line: 1, column: 14))
      ], "Tokens should be equal")
  }

  func testString() {
    XCTAssertEqual(Lexer("\"Hello World!\"").scan(), [
      create(.StringLiteral, "\"Hello World!\"", "Hello World!", Location(position: 11, line: 1, column: 12)),
      createEOF(Location(position: 13, line: 1, column: 14))
    ], "Tokens should be equal")
  }
  
  func testNumber() {
    XCTAssertEqual(Lexer("1").scan(), [
      create(.NumberLiteral, "1", 1, Location(position: 1, line: 1, column: 2)),
      createEOF(Location(position: 2, line: 1, column: 3))
    ], "Tokens should be equal")
    
    XCTAssertEqual(Lexer("1.0").scan(), [
      create(.NumberLiteral, "1.0", 1.0, Location(position: 3, line: 1, column: 4)),
      createEOF(Location(position: 4, line: 1, column: 5))
    ], "Tokens should be equal")
    
    XCTAssertNotEqual(Lexer("1.0.0").scan(), [
      create(.NumberLiteral, "1.0.0", 1.0, Location(position: 5, line: 1, column: 6)),
      createEOF(Location(position: 6, line: 1, column: 7))
      ], "Tokens should be equal")
  }

  static var allTests = [
    ("testHelloWorld", testHelloWorld),
    ("testString", testString),
    ("testNumber", testNumber)
  ]
}
