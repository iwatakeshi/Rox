//
//  ParserTests.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/10/17.
//
//

import XCTest
import Core

class ParserTests: XCTestCase {
  let lexer: Lexer = Lexer()
  let printer: ASTPrinter = ASTPrinter()
  
  private func parse(_ source: String) -> String {
    do {
      return try printer.print(Parser(lexer.scan(source)).parse())
    } catch {
      return ""
    }
  }
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
    
  func testParseBinary() {
    XCTAssertEqual(parse("1 + 1"), "(+ 1 1)")
    XCTAssertEqual(parse("1 - 1"), "(- 1 1)")
    XCTAssertEqual(parse("1 * 1"), "(* 1 1)")
    XCTAssertEqual(parse("1 / 1"), "(/ 1 1)")
    XCTAssertEqual(parse("1 * 2 + 1"), "(+ (* 1 2) 1)")
    XCTAssertEqual(parse("1 * (2 + 1)"), "(* 1 (group (+ 2 1)))")
    XCTAssertEqual(parse("(1 + 1) * 1 / 2 + (4 - 1)"), "(+ (* (group (+ 1 1)) (/ 1 2)) (group (- 4 1)))")
  }
  
  func testParenthesized() {
    XCTAssertEqual(parse("(1 * 2)"), "(group (* 1 2))")
  }
  
  func testUnary() {
    XCTAssertEqual(parse("-1"), "(- 1)")
    XCTAssertEqual(parse("!1"), "(! 1)")
  }
  
  func testLiteral() {
    XCTAssertEqual(parse("1"), "1")
    XCTAssertEqual(parse("0.11"), "0.11")
    XCTAssertEqual(parse("true"), "true")
    XCTAssertEqual(parse("false"), "false")
    XCTAssertEqual(parse("null"), "null")
    XCTAssertEqual(parse("\"Hello world\""), "Hello world")
    
  }
    
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
    
}
