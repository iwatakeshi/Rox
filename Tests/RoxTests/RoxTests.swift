import XCTest
import Core

class RoxTests: XCTestCase {
  
  private func createEOF(_ location: Location) -> Token {
    return Token(.EOF, "", nil, location)
  }
  
  func testHelloWorld() {
    XCTAssertEqual(Lexer("Hello World!").scan(), [
      Token(.Identifier, "Hello", "Hello", Location(5, 1, 6)),
      Token(.Identifier, "World", "World", Location(11, 1, 12)),
      Token(.Operator("!"), "!", nil, Location(12, 1, 13)),
      createEOF(Location(13, 1, 14))
      ], "Tokens should be equal")
  }

  func testString() {
    XCTAssertEqual(Lexer("\"Hello World!\"").scan(), [
      Token(.StringLiteral, "\"Hello World!\"", "Hello World!", Location(11, 1, 12)),
      createEOF(Location(13, 1, 14))
    ], "Tokens should be equal")
  }
  
  func testNumber() {
    XCTAssertEqual(Lexer("1").scan(), [
      Token(.NumberLiteral, "1", 1, Location(1, 1, 2)),
      createEOF(Location(2, 1, 3))
    ], "Tokens should be equal")
    
    XCTAssertEqual(Lexer("1.0").scan(), [
      Token(.NumberLiteral, "1.0", 1.0, Location(3, 1, 4)),
      createEOF(Location(4, 1, 5))
    ], "Tokens should be equal")
    
    XCTAssertNotEqual(Lexer("1.0.0").scan(), [
      Token(.NumberLiteral, "1.0.0", 1.0, Location(5, 1, 6)),
      createEOF(Location(6, 1, 7))
      ], "Tokens should be equal")
  }

  static var allTests = [
    ("testHelloWorld", testHelloWorld),
    ("testString", testString),
    ("testNumber", testNumber)
  ]
}
