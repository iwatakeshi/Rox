//
//  ParserTests.swift
//  Rox
//
//  Created by Takeshi Iwana on 8/10/17.
//
//

import XCTest
import RoxCore

class ParserTests: XCTestCase {
  let lexer = Lexer()
  let parser = Parser()
  let printer = ASTPrinter()
  
  private func parse(_ source: String) -> String {
    do {
      return try printer.print(parser.parse(lexer.scan(source), type: .Expression) as? Expression)
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
    XCTAssertEqual(parse("(5 - (3 - 1)) + -1"), "(+ (group (- 5 (group (- 3 1)))) (- 1))")
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
  
  func testExpression() {
    //(5 - (3 - 1)) + -1
    XCTAssertEqual(parse("(5 - (3 - 1)) + -1"), "(+ (group (- 5 (group (- 3 1)))) (- 1))")
  }
    
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
    
}
