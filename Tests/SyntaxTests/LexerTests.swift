//
//  LexerTest.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/10/17.
//
//

import XCTest
import RoxCore

class LexerTests: XCTestCase {
  
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
  private func createEOF(_ location: Location) -> Token {
    return Token(.EOF, "", nil, location)
  }
  
  func testScanHelloWorld() {
    XCTAssertEqual(Lexer("Hello World!").scan(), [
      Token(.Identifier, "Hello", "Hello", Location(5, 1, 6)),
      Token(.Identifier, "World", "World", Location(11, 1, 12)),
      Token(.Operator("!"), "!", nil, Location(12, 1, 13)),
      createEOF(Location(13, 1, 14))
      ], "Tokens should be equal")
  }
  
  func testScanString() {
    XCTAssertEqual(Lexer("\"Hello World!\"").scan(), [
      Token(.StringLiteral, "\"Hello World!\"", "Hello World!", Location(11, 1, 12)),
      createEOF(Location(13, 1, 14))
      ], "Tokens should be equal")
  }
  
  func testScanNumber() {
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
  
  func testScanComment() {
    XCTAssertEqual(Lexer("# Hello world!").scan(), [
      createEOF(Location(1, 1, 2))
    ])
  }
  
  func testScanPerformance() {
    var text = "Hello world! This is a very long text. To evaluate the performance,"
    text.append("we will need to evaluate the following text...")
    text.append("\n")
    text.append("var id = 1")
    text.append("\n")
    text.append("class Car () {}")
    text.append("\n")
    text.append("var id = 4.23")
    text.append("\n")
    text.append("2 * 2 + (3 + 2)")
    text.append("\n")
      // This is an example of a performance test case.
    self.measure {
      _ = Lexer(text).scan()
    }
  }
    
}
